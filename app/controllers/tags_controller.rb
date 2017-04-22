class TagsController < ApplicationController
  before_action :set_tag, only: [:show]

  def show
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  private
    def set_tag
      @tag = Tag.find(params[:id])
    end
end
