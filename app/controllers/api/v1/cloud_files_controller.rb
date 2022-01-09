# frozen_string_literal: true

module Api
  module V1
    class CloudFilesController < Api::V1Controller
      def reserve
        raise SecurityError unless Bucket.exists?(user_id: current_user.id, id: reservation_params[:bucket_id])
        raise IndexError if CloudFile.exists?(md5: reservation_params[:md5], folder_id: reservation_params[:folder_id])

        cloud_file = CloudFile.new(reservation_params)
        cloud_file.reserve!
        render json: cloud_file.attributes
      rescue SecurityError
        render json: { message: 'bucket is not owned by user' }, status: 401
      rescue IndexError
        render json: { message: 'md5 already exists in this folder' }, status: 422
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

      ############################################################################
      private
      ############################################################################

      def authorize
        if current_user.cloud_files.where(md5: params[:id]).blank?
          render json: { status_msg: :ok, message: 'proceed with upload' }
        else
          render json: { status_msg: :error, message: "file already exists w/ md5 #{params[:id]}" }, status:  401
        end
      end

      def folder_params
        params.require(:folder).permit(:fullpath, :peepy, :nsfw, :bucket_id)
      end

      def folder
        Folder.find_or_create_from_path(
          fullpath:  folder_params[:fullpath],
          bucket_id: folder_params[:bucket_id],
          peepy:     folder_params[:peepy],
          nsfw:      folder_params[:nsfw]
        )
      end

      def reservation_params
        params.permit(:bucket_id, :md5).merge(user_id: current_user.id, folder: folder)
      end

      def transfer_params
        params.permit(:content_type, :asset, :filesize).merge(user_id: current_user.id)
      end

      def complete_params
        {
          user_id: current_user.id
        }.merge(
          tags: params.require(:tags).permit(:genre, :comment),
          cloud_file_attributes: params.require(:cloud_file_attributes).permit(:year, :folder, :rating, :release),
          matched_recording: params.require(:matched_recording)
                                  .permit(:id, :duration, :title,
                                          releasegroups: [:title, :id])
        )
        # , artist:  %i[id name]
      end
    end
  end
end
