# frozen_string_literal: true

module Admin
  class TopController < Base
    def index
      render action: 'index'
    end
  end
end
