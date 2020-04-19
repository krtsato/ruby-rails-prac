# frozen_string_literal: true

class Customer::TopController < ApplicationController # rubocop:disable Style/ClassAndModuleChildren
  def index
    render action: 'index'
  end
end
