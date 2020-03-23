# frozen_string_literal: true

module Staff
  class TopController < Base
    def index
      render action: 'index'
    end
  end
end
