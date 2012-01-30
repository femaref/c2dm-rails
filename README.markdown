# c2dm-rails

c2dm-rails provides infrastructure to send push notifications to Android devices via google [c2dm](http://code.google.com/android/c2dm/index.html).

##Installation

    $ gem install c2dm-rails
    $ rake c2dm:install:migrations
    $ rake db:migrate

  After you installed the gem, you need to generate the migrations necessary for the gem to work and run them.
    
##Requirements

An Android device running 2.2 or newer, its registration token, and a google account registered for c2dm.

##Usage

The gem is database driven. First of all, you need to create an app with the following credentials:

  username: the username of the google account you entered in the c2dm registration
  password: password for this account
  application_id: the package of the android app (e.g. com.example)
  sender_id: email account associated with the registration process. Can be the same as the user used to login
  source: application identifier for google logging purposes. Should be of the form "companyName-applicationName-versionID"

This can be done from the console, as these credentials won't change much.

After you configured the app, you'll need to add devices to it. A device is identified by a registration_id, this can be send by the client each time it logs in, or can be done explicitly with a controller.

Once you have the device, you are able to add messages to it, simply create a new C2dm::Notification object via device.notifications.new with the following information:

  data: a hash, { :key1 => "value1", :key2 => "value2" }
  delay_while_idle: boolean telling the google server if it should wake the device if it is idle
  collapse_key: this details a group of messages. If the device is offline, it will only receive the "last" message. As there is now guarantee of delivering order, the "last" message might not be last message sent by your application

Any other field is used to keep state by the delivery engine and should not be modified.

After you added messages, get an instance of your app and send the messages:

  app = C2dm::App.find(some_id)
  app.deliver_notifications

The app contains an exponential back-off mechanism for notifications that failed to deliver. It is of the form `last_sent_date` + 10 ** tries, with a maximum of 4 tries (about three hours).



##Copyrights

* Copyright (c) 2010-2011 Heiko Moeller, empuxa gmbh. See LICENSE.txt for details.

##Thanks

* [amro](https://github.com/amro/c2dm) for the basis of this gem