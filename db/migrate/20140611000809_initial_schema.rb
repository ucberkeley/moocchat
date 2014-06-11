class InitialSchema < ActiveRecord::Migration
  def up

    # the Users table uses single-table inheritance to distinguish
    # Learners, Instructors, Administrators
    create_table :users, :force => true do |t|
      t.timestamps
      t.string :type
      t.string :name
    end

    # Join tables for the HABTM relations with cohorts
    create_table :cohorts_learners, :force => true, :id => false do |t|
      t.belongs_to :cohorts
      t.belongs_to :learners
    end

    create_table :cohorts_instructors, :force => true, :id => false do |t|
      t.belongs_to :cohorts
      t.belongs_to :instructors
    end

    # Cohort
    create_table :cohorts, :force => true do |t|
      t.timestamps
      t.string :name
    end

    # Experimental condition - a sequence of pages flanked by prolog/epilog
    create_table :conditions, :force => true do |t|
      t.timestamps
      t.string :name
      t.text :prologue
      t.text :body
      t.text :epilogue
    end

    # activity schema
    create_table :activity_schemas, :force => true do |t|
      t.timestamps
      t.belongs_to :cohort
      t.boolean :enabled        # is activity 'live'?
      t.boolean :randomized      # should question order be randomized?
      t.integer :num_questions # how many times to instantiate condition body?
      t.string :tag            # instructor's reference name (for analysis)
      t.string :name           # student-facing activity name
    end

    # a task unites the triple <learner, activity_schema, condition>
    create_table :tasks, :force => true do |t|
      t.timestamps
      t.belongs_to :activity_schema
      t.belongs_to :learner
      t.belongs_to :condition
      t.string :chat_group
      t.integer :current_question # where are we in the task?
      t.boolean :completed        # sticky bit set when task is completed
    end

    # questions
    create_table :questions, :force => true do |t|
      t.timestamps
      t.text :text    # free text or HTML
      t.text :answers # serialized array of strings
      t.integer :correct_answer_index # which is the single correct answer?
    end

    # HTML+CSS templates
    create_table :templates, :force => true do |t|
      t.timestamps
      t.string :name
      t.string :url
    end

  end

  def down
  end
end
