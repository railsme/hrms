class Person < ActiveRecord::Base
  acts_as_taggable_on :tags

  PRIMARY_TECHS = %w(
    Ruby
    Frontend
    Fullstack
    NET
    Java
    iOS
    Android
    Salesforce
    DevOps
    PM
    QA/BA
    C/C++/Go
    HR
  )
  ENGLISH_LEVELS = %w(
    Beginner/Elementary
    Pre-Intermediate
    Intermediate
    Upper-Intermediate
    Advanced
  )
  SEARCH_STR = %w[name city phone skype linkedin facebook primary_tech english
    notes_value action_points_value].join('_or_') << '_cont'

  belongs_to :updated_by, class_name: 'User'
  has_many :action_points
  has_many :assessments
  has_many :attachments
  has_many :notes

  validates :name, presence: true
end
