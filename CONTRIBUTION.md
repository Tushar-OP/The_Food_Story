# CONTRIBUTION GUIDE 📝

This project is built with flutter and firebase as the database

### Local Setup

- [Fork](https://github.com/Tushar-OP/The_Food_Story/fork) this repository

*Note: This project is originally developed on a windows machine, so Linux users might face some errors regarding gradle, please google them. (This happened to me, just a heads up)*

```
git clone https://github.com/Tushar-OP/The_Food_Story
cd The_Food_Story
flutter run
```

- As stated above this project uses firebase as database (hold your stones, it was the easiest method for me to start with the project so I started). I have not included my google-services file in the project for security reasons(Duh), so you have to create a firebase project. 

#### Creating Firebase Project
- You can follow this [written guide](https://firebase.google.com/docs/flutter/setup?platform=android) or [video](https://www.youtube.com/watch?v=DqJ_KjFzL9I) or if you know then move onto the <em>database schema<em/>
  
#### Database Schema
*Note: Please keep the field names <b>exactly</b> the same to avoid errors*
- So, there are <b>two top-level collections</b> namely 
  - Posts
  - Users
- In Posts, we have documents with auto-generated UID and fields:
  - image (String)
  - email (String)
  - description (String)
  - likes (List<String>)
  - createdAt (Timestamp)
  - updatedAt (Timestamp)
  - user  (User UID)
  
- In Users, we have documents with User UID (one that is generated after signing up with email and password, can be found in authentication tab) and fields:
  - displayName (String)
  - email (String)
  - followers (List<User UID i.e String>)
  - following (List<User UID i.e String>)
  - posts (List<String>)
  - profilePicture (String)
  - savedPosts (List<Posts UID i.e String>)

### Hello, first-time contributors 👋
- If you are thinking to contribute for the first time and read up till here, give it a try it is really not that difficult as I'm making it seem by such extra instructions. They are ony for clarity so things go as smoothly as possible.
- There are lot of resources (articles, courses, videos) available for getting started with git and GitHub you can search and follow any of the resource you like.
  - You can pick any of the issues from Issues or If you feel like it needs extra feature or if you find bug, you can create your own issue.
  - You can drop a comment on issue saying "Hi tushar, let me work on this or I will kill you 🔪" to avoid multiple people working on the same PR.
  - Lastly, It is fine if you mess something up. If there is anything wrong in the PR I will let you know how to fix that in comments of the PR.

If you are still scared to drop a PR or need any help, you can always drop me a message on my Twitter [@Tushar_OP](https://twitter.com/Tushar_OP) or drop me an email at tusharpatilmarch@gmail.com.

Thank you for your time!
