The callenge is chat system that has multiple Application identified by token, each Application has many chats identified by a number ( number should start from 1) , each Chat has many messages identified by a number ( number should start from 1)
- The endpoints should be RESTful
- Use MySQL2 as datastore
- Use ElasticSearch for searching through messages of a specific chat
- Use Sidekiq to run background jobs

# My Approach
### Understand the requirements
- Extract classes (Application, Chat, Message)
- Define Relations between classes

