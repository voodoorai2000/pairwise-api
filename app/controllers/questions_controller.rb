class QuestionsController < InheritedResources::Base
  respond_to :xml, :json
  belongs_to :site, :optional => true
  #has_scope :voted_on_by

  def show
    show! do |format|
      session['prompts_ids'] ||= []
      format.xml { 
        render :xml => @question.to_xml(:methods => [:item_count, :left_choice_text, :right_choice_text, :picked_prompt_id, :votes_count, :creator_id])
        }
    end
  end
  
  def create
    authenticate
    if @question = current_user.create_question(params[:visitor_identifier], params.except[:visitor_identifier])
      respond_to do |format|
        format.xml { render :xml => @question.to_xml}
      end
    else
      respond_to do |format|
        format.xml { render :xml => @question.errors.to_xml}
      end
    end
  end
  
end
