# frozen_string_literal: true

module Api
  module V1
    class CloudFilesController < Api::V1Controller

      # def create
      #   begin
      #     # just querying to make sure the user owns the bucket. if a user's bucket isn't found this will raise an error
      #     current_user.buckets.find(params[:cloud_file][:bucket_id])
      #     params[:cloud_file][:relative_path] = nil if params[:preserve_tree].blank?
      #     cloud_file = CloudFile.create! params.require(:cloud_file).permit(:name, :asset, :md5, :content_type, :filesize, :description, :rating, :nsfw, :bucket_id, :folder_id, :info_url, :tag_list, :metadata_list, :relative_path)
      #     render(json: { status:  200, status_msg: :ok, message:  "#{cloud_file.asset} has been uploaded to #{cloud_file.url}" })
      #   rescue Exception =>  error
      #     render(json: { status:  401, message:  error.message }, status:  :unauthorized)
      #   end
      # end

      def reserve
        cloud_file = CloudFile.new(reservation_params)
        cloud_file.reserve!
        render json: cloud_file.attributes
      rescue StandardError => e
        render json: { message: e.message }, status: 500
      end

      def transfer
        cloud_file = CloudFile.find_by_md5(params[:md5])
        cloud_file.transfer!(transfer_params)
        render json: cloud_file.attributes
      end

      def complete
        cloud_file = CloudFile.find_by_md5(params[:md5])
        cloud_file.complete!(complete_params)
        render json: cloud_file.attributes
      end

      def authorize
        if current_user.cloud_files.where(md5: params[:id]).blank?
          render json: { status_msg: :ok, message: 'proceed with upload' }
        else
          render json: { status_msg: :error, message: "file already exists w/ md5 #{params[:id]}" }, status:  401
        end
      end

      def reservation_params
        params.permit(:bucket_id, :md5).merge(user_id: current_user.id)
      end

      def transfer_params
        params.permit(:content_type, :asset, :filesize).merge(user_id: current_user.id)
      end

      def complete_params
        params.permit(:folder).merge(
          user_id: current_user.id,
          tags: params.require(:tags).permit(:genre, :comment),
          cloud_file_attributes:
            params.require(:cloud_file_attributes).permit(:year, :folder, :rating, :release),
          matched_recording:
            params.require(:matched_recording)
                  .permit(:id, :duration, :title,
                          releasegroups: [:title, :id])
        )
        # , artist:  %i[id name] 
      end
    end
  end
end
