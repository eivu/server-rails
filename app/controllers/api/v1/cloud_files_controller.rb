# frozen_string_literal: true

module Api
  module V1
    class CloudFilesController < Api::V1Controller

      def create
        begin
          # just querying to make sure the user owns the bucket. if a user's bucket isn't found this will raise an error
          current_user.buckets.find(params[:cloud_file][:bucket_id])
          params[:cloud_file][:relative_path] = nil if params[:preserve_tree].blank?
          cloud_file = CloudFile.create! params.require(:cloud_file).permit(:name, :asset, :md5, :content_type, :filesize, :description, :rating, :nsfw, :bucket_id, :folder_id, :info_url, :tag_list, :metadata_list, :relative_path)
          render(json: { status:  200, status_msg: :ok, message:  "#{cloud_file.asset} has been uploaded to #{cloud_file.url}" })
        rescue Exception =>  error
          render(json: { status:  401, message:  error.message }, status:  :unauthorized)
        end
      end

      def reserve
        render json: {a: :b}
      end

      def upload
        binding.pry
      end

      def tag
        binding.pry
      end

      def authorize
        if current_user.cloud_files.where(md5: params[:id]).blank?
          render json: { status_msg: :ok, message:  'proceed with upload' }
        else
          render json: { status_msg: :error, message: "file already exists w/ md5 #{params[:id]}" }, status:  401
        end
      end
    end
  end
end
