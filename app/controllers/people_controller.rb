class PeopleController < ApplicationController
  load_and_authorize_resource
  autocomplete :person, :name, full: true

  def index
    @q = Person.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @people = @q.result(distinct: true)

    if params.dig(:q, :by_tag_including)
      @people = @people.tagged_with(params[:q][:by_tag_including], any: true)
    end
    if params.dig(:q, :by_tag_excluding)
      @people = @people.tagged_with(params[:q][:by_tag_excluding], exclude: true)
    end

    @people = @people.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @people = @people.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @people = @people.includes(:notes, :attachments, :assessments, :action_points, :updated_by)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def show
  end

  def new
  end

  def create
    @person = Person.new(person_params.merge!(updated_by: current_user))
    if @person.save
      log_event(entity: @person, action: 'created')
      redirect_to people_path, flash: { success: 'Person created' }
    else
      flash.now[:error] = 'Person was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @person.update(person_params.merge!(updated_by: current_user))
      log_event(entity: @person, action: 'updated')
      redirect_to people_path, flash: { success: 'Person updated' }
    else
      flash.now[:error] = 'Person was not updated'
      render :edit
    end
  end

private

  def person_params
    params.require(:person).permit(:name, :city, :phone, :skype, :linkedin, :email, :facebook, :wants_relocate,
      :primary_tech, :english, :cultural_fit, :day_of_birth, :created_at, tag_list: [])
  end
end
