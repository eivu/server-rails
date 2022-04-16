# frozen_string_literal: true

module Api
  module V1
    class CloudFilesController < Api::V1Controller
      def show
        cloud_file = current_user.cloud_files.includes(:bucket).find_by(md5: params[:md5])
        raise ActiveRecord::RecordNotFound if cloud_file.blank?

        render json: cloud_file
      end

      def reserve
        raise SecurityError unless Bucket.exists?(user_id: current_user.id, id: reservation_params[:bucket_id])
        raise IndexError if CloudFile.exists?(md5: reservation_params[:md5], bucket_id: reservation_params[:bucket_id])

        cloud_file = current_user.cloud_files.new(reservation_params)
        cloud_file.reserve!
        render json: cloud_file.attributes
      rescue SecurityError
        render json: { message: 'bucket is not owned by user' }, status: 401
      rescue IndexError
        render json: { message: 'md5 already exists in this folder' }, status: 422
      end

      def transfer
        cloud_file = current_user.cloud_files.find_by_md5(params[:md5])
        raise IndexError unless cloud_file.reserved?

        cloud_file.transfer!(transfer_params)
        render json: cloud_file.attributes
      rescue IndexError
        render json: { message: 'md5 is not for a reserved file' }, status: 422
      end

      def complete
        cloud_file = current_user.cloud_files.find_by_md5(params[:md5])
        cloud_file.complete!(complete_params)
        render json: cloud_file.attributes
      end

      def online
        cloud_file = current_user.cloud_files.find_by_md5(params[:md5])
        if cloud_file.online?
          render json: { message: 'file is online', online: cloud_file.online? }
        else
          render json: { message: 'file is offline', online: cloud_file.online? }, status: 404
        end
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

      def folder
        Folder.find_or_create_from_path(
          fullpath: params[:fullpath],
          bucket_id: params[:bucket_id],
          peepy: params[:peepy],
          nsfw: params[:nsfw]
        )
      end

      def reservation_params
        params.permit(:bucket_id, :md5, :peepy, :nsfw).merge(user_id: current_user.id, folder: folder)
      end

      def transfer_params
        params.permit(:content_type, :asset, :filesize)
      end

      def complete_params
        params.permit!.slice(:year, :rating, :release_pos, :metadata_list, :matched_recording)
      end
    end
  end
end
