class Note < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = [
    'Email',
    'LinkedIn Message',
    'Initial Interview',
    'Initial Interview - Office',
    'Skype Conversation',
    'Skype Call',
    'Phone Call',
    'Tech Interview',
    'Tech Interview - Office',
    'Additional Interview',
    'Additional Interview - Office',
    'Test Assignment',
    'Decision',
    'CEO Opinion',
    'Interview With CEO',
    'Recommended',
    'Looking for Job',
    'Changed Job',
    'Salary',
    'Other'
  ]
  RESTRICTED_TYPES = [
    'Salary'
  ]

  belongs_to :person, counter_cache: true, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :type, :person, :value, presence: true
  validates :type, inclusion: { in: TYPES }
end
