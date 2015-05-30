class SetRegions < ActiveRecord::Migration
  def up
    [
      {:descr => "US Standard *", :name => "us-east-1",:endpoint => "s3.amazonaws.com",:location => ""},
      {:descr => "US West (Oregon)", :name => "us-west-2",:endpoint => "s3-us-west-2.amazonaws.com",:location => "us-west-2"},
      {:descr => "US West (N. California)", :name => "us-west-1",:endpoint => "s3-us-west-1.amazonaws.com",:location => "us-west-1"},
      {:descr => "EU (Ireland)", :name => "eu-west-1",:endpoint => "s3-eu-west-1.amazonaws.com", :location => "EU or eu-west-1"},
      {:descr => "EU (Frankfurt)", :name => "eu-central-1",:endpoint => "s3.eu-central-1.amazonaws.com",:location => "eu-central-1"},
      {:descr => "Asia Pacific (Singapore)", :name => "ap-southeast-1",:endpoint => "s3-ap-southeast-1.amazonaws.com",:location => "ap-southeast-1"},
      {:descr => "Asia Pacific (Sydney)", :name => "ap-southeast-2",:endpoint =>"s3-ap-southeast-2.amazonaws.com",:location => "ap-southeast-2"},
      {:descr => "Asia Pacific (Tokyo)", :name => "ap-northeast-1",:endpoint => "s3-ap-northeast-1.amazonaws.com",:location => "ap-northeast-1"},
      {:descr => "South America (Sao Paulo)", :name => "sa-east-1",:endpoint => "s3-sa-east-1.amazonaws.com",:location => "sa-east-1"}
    ].each do |hash|
      Region.create! hash
    end
  end

  def down
    Region.destroy_all
  end
end
