# frozen_string_literal: true

module Admin
  class TopController < Base
    def index
      if current_administrator
        render action: 'dashboard'
      else
        render action: 'index'
      end
    end
  end
end
