# frozen_string_literal: true

# Base API controller
class ApplicationController < ActionController::API
  before_action :active_storage_current_host

  private

  def render_json(object, serializer)
    render json: object, serializer: serializer
  end

  def record_not_found(error)
    render json: {
      errors: [
        {
          status: 404,
          title: 'Record Not Found',
          details: error.to_s
        }
      ]
    }, status: :not_found
  end

  def active_storage_current_host
    ActiveStorage::Current.url_options = { host: request.base_url }
  end
end
