# frozen_string_literal: true

module Staff
  class TopController < ApplicationController
    def index
      render action: 'index'
    end
  end
end
