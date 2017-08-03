User.create(username: "Pickles", email: "mail@mail.com", password: "password")
Group.create(name: "Group One", creator_id: 1, description: "Described")
GroupMember.create(user_id: 1, group_id: 1)
