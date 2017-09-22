class Ps2Controller < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  before_action :cookie_setup, :only => [:quotations, :quotations_search]
  $ids_to_kill = 0

  def quotations
    $ids_to_kill = cookies[:killer].split(" ")

    if params[:sort_by] == "date"
      @quotations = Quotation.where('id NOT IN (?)', $ids_to_kill).order(:created_at)
    else
      @quotations = Quotation.where('id NOT IN (?)', $ids_to_kill).order(:category)
    end

    q = @quotations #because this way xml render works
    respond_to do |format|
      format.html
      format.xml { render :xml => q.to_xml }
      format.json { render :json => @quotations.to_json}
    end
  end

  def create
    if params[:author_name] != "" && params[:quote] != ""
      if params[:Categories] == "new category"
        if params[:new_category]
          @quotation = Quotation.new( quote: params[:quote], author_name: params[:author_name], category: params[:new_category])
          if @quotation.save
            flash[:notice] = 'Quotation was successfully created.'
            redirect_to ps2_quotations_path
          end
        else
          flash[:create] = "New Category missing..."
        end
      else
        @quotation = Quotation.new( quote: params[:quote], author_name: params[:author_name], category: params[:Categories])
        if @quotation.save
          flash[:notice] = 'Quotation was successfully created.'
          redirect_to ps2_quotations_path
        end
      end
    end
  end

  def quotations_search
    #searching keyword both in qutoe and author_name
    @keyword = params[:keyword]

    @results_from_quote = Quotation.where('quote LIKE ? AND id NOT IN (?)', "%#{@keyword}%", $ids_to_kill).all
    @results_from_author_name = Quotation.where('author_name LIKE ? AND id NOT IN (?)', "%#{@keyword}%", $ids_to_kill).all
  end

  def sql_problem_set
<<<<<<< HEAD
    send_file "#{Rails.root}/SQL_Solutions.txt"
=======
    @data = File.read("#{Rails.root}/something.txt")
>>>>>>> 04a8868d16a2c2b9014fd1b34c3a4f854891f1e0
  end

  def quotation_doc
  end

  def sql_ps_doc
  end

  def import_quotations
    @url = params[:url]

    doc = Nokogiri::XML(open(@url))

    for @entry in doc.xpath("//quotation")

      xml_value = Quotation.create(
        :quote => @entry.css("quote").inner_text,
        :author_name => @entry.css("author_name").inner_text,
        :category => @entry.css("category").inner_text ,
      )

      xml_value.save
    end
    redirect_to ps2_quotations_path
  end

  private
  def cookie_setup
    @id_to_kill = params[:id]

    #when we have an id to kill
    if @id_to_kill
      #erase code -1
      if @id_to_kill == "-1"
        cookies[:killer] = "0"
      #for any other id add it to the value of cookie
      else
        cookies[:killer] = "#{cookies[:killer]} #{@id_to_kill}"
      end
    #for first time
    else
      if cookies[:killer].blank?
        #initiating cookie Killer
        cookies[:killer] = {
          value: "0",
          expires: 1.year.from_now
        }
      end
    end
  end
end
