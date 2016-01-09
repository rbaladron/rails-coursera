Book.destroy_all

Book.create! [
  { name: "Eloquent Ruby", author: "Russ Olsen"},
  { name: "Beginning Ruby", author: "Peter Cooper"},
  { name: "Metaprogramming Ruby 2", author: "Paolo Perrota"},
  { name: "Design Patterns in Ruby", author: "Russ Olsen"},
  { name: "The Ruby Programming Language", author: " David Flanagan"}
]

eloquent = Book.find_by name: "Eloquent Ruby"
eloquent.notes.create! [
  { title: "Wow", note: "Great book to learn Ruby"},
  { title: "Funny", note: "Doesn't put you to sleep"}
]

reviewers = Reviewer.create! [
  { name: "Joe", password: "abc123"};
  { name: "Jim", password: "123abc"}
]

Book.all.each do |book|
  book.reviewer = reviewers.sample
  book.save!
end
