# BunnyHop
BunnyHop is a thin wrapper around RabbitMQ's bunny driver. It provides an opinion
about the structure of messages and message handling.

BunnyHop is broken down into three independent components.

## Manager
The `manager` is used to create, modify and delete queues/subscriptions:

    manager = BunnyHop.manager({
      application: 'sample',
      exchange: 'foodrunner',
      host: '127.0.0.1',
      port: 5672,
      username: 'user',
      password: 'pass'
    })
    manager.subscribe('my-queue', ['models.v1.users.#', 'models.v2.items.delete'])
    manager.unsubscribe('my-queue', [models.v2.items.delete'])
    manager.delete('my-queue')

## Writer
The `writer` is used to write `create`, `update` or `delete` messages to te queue:

    writer = BunnyHop:.writer({
      application: 'sample',
      exchange: 'foodrunner',
      host: '127.0.0.1',
      port: 5672,
      username: 'user',
      password: 'pass'
    })

    writer.create(:v1, :users, 9001, {name: 'leto'})
    writer.update(:v2, :items, 23, {name: 'food'})
    writer.delete(:v1, :users, 9001)

The generated route is in the format of PREFIX.VERSION.RESOURCE.ACTION. The default
prefix is 'models', therefore, the above commands generate messages to these respective
routes:

    'models.v1.users.create'
    'models.v2.items.update'
    'models.v1.users.delete'

To use a different prefix, an optional settings parameter can be supplied to
`create`, `update` and `delete`:

    // message route will be 'summary.v1.users.create'
    writer.create(:v1, :users, 9001, {name: 'leto'}, {prefix: 'summary'})

## Reader
The reader listens for messages sent to a specific queue and executes an appropriate handler:

    class Controller
      def self.create_users(message)
        # process the message
        # returning true consumes the message
        true
      end

      def self.error(e)
        # process the error
        # returning true consumes the message
        false
      end
    end

    reader = BunnyHop.reader({
      host: '127.0.0.1',
      port: 5672,
      username: 'test',
      password: 'test'
    })

    reader.run('test-queue', Controller)

Action names take the form of ACTION_MODEL. Messages expose various properties:

- version
- resource
- action
- id
- payload
- time
- client

Messages aren't consumed until either the action handler or the generic handler return true. As a consequence, should the system fail after you've processed a message but before it is fully acknowledged, the same message will be received once the system is back up and running. One solution is to independently track processed message. A better approach is to make your system idempotent.
