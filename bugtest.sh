rm db.development-master.sqlite3
rake db:migrate
rake db:seed
rake db:test:prepare
rake cucumber
rake spec