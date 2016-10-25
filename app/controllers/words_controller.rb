class WordsController < ApplicationController
  before_action :authenticate_user!
  def show
  end

  def new
  end

  def create
    Word.create(jaword:params[:word][:jaword],enword: params[:word][:enword])
    puts "PARAMS is #{params[:word][:jaword]}"
  end

  def update
  end

  def index
  end

  def batch
  end
  def tsv
    tsv = params[:q]
    data = Word.createFromTsv(tsv)
    render 'index'
  end
end
