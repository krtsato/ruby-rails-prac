# frozen_string_literal: true

module Staff
  class TopController < Base
    skip_before_action :authorize

    def index
      render action: 'index'
    end
  end
end
