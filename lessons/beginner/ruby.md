# Beginner Ruby

## Hello there!

### Let's get started

Welcome to your first lesson in Ruby! You're going to have a blast.

Ruby is a great programming language that you can use to make all kinds of
things with. Let's get going!

Click the icon like this (on the bottom of the screen) to get started:

![Not this one! The one below!](/icon_button/arrow_right)

### Lesson Controls

Before we move on, Here's a refresher on the controls you can use to move around
in the Lesson.

![](/icon_button/arrow_left)
__back__: goes back one page

![](/icon_button/arrow_right)
__continue__: goes to the next page

![](/icon_button/menu)
__menu__: makes it easy to jump around to any lesson

![](/icon_button/x)
__close__: closes the tutor

Don't forget! Press this to move to the next part:

![](/icon_button/arrow_right)

Have at it!

## A bit more about Ruby

### Konnichiwa, Ruby!

_Ruby_ was created by 

まつもと ゆきひろ

(you can just call him Matz) in 1995. If you couldn't guess, Matz is from
Japan. Here he is:

![](static/matz.jpg)

### Ruby is enjoyable

Matz has this to say about Ruby:

_I hope to see Ruby help every programmer in the world to be productive, and to
enjoy programming, and to be happy. That is the primary purpose of Ruby
language._

One more thing about Ruby: Rubyists (that's what people who like Ruby call
themselves) have a saying: __MINSWAN__. This stands for __M__atz __I__s __N__ice
__S__o __W__e __A__re __N__ice. Which is a pretty nice saying, itself. Be nice
to everyone, and give them a hand when they need it!

## Displaying Things

### Let's do this!

Okay! The very first thing that you need to know is how to show something on the
screen. Otherwise, you won't know what's going on!

In order to start coding, we need to bring up the Editor. Its icon looks like
this:

![Not this one, silly! the one on the left!](static/tab-new.png)

Click the icon to open the Editor up, and then we'll move on...

### Hello, World!

There are two ways of doing this. Here's the first: alert

    alert "Hello, world!"

Type this in and press the 'Run' button.

### alert

Okay, let's break this down: There's two main parts to this little program: you
have an `alert`, and a `"Hello, world!"`. These two parts work just like an
English sentence: The `alert` is a verb and the stuff in the ""s is an object.
In Ruby, we call verbs __methods__. The `alert` verb says 'Put an alert box on
the screen, and the content of the box is whatever thing you give me.'

We'll talk about the `"Hello, world!"` in just a second. Here's the other way of
making this happen: 

    puts "Hello, world!"

But if you try that here, it won't work! The `puts` method doesn't display a
dialog box, it puts text out to a command-line prompt. Since Hackety Hack is all
graphical, this doesn't work here. So we'll be using `alert`s throughout these
tutorials, but if you look at other Ruby tutorials, you may see `puts`.

## Letters, words, and sentences

### Strings

Okay! Now that you've got that verb bit down, it's time to learn about
_String_s. Strings are what we call a bunch of words between a pair of "
characters. The "s are used to tell the computer what words you actually want to
say. Let's think about our example:

    alert "Hello, world!"

If you didn't have the "s, the computer wouldn't know which words were methods
and which ones were part of the string! And consider this:

    alert "I am on high alert!"

Without making all of those words a string, how would Ruby know that the second
alert was some text you wanted to say, rather than another alert box?

### Adding Strings

Now, if you want to put two bits of strings together, you can use the `+`
character to do it. Try typing this:

    alert "Hello, " + "world!"

Same thing! The `+` sticks the two strings together. This will end up being
super useful later!

## Numbers and Math

### Numbers

You can just use numbers, and Ruby understands them:

    alert 2

You can even use numbers that have a decimal point in them:

    alert 1.5

### Basic Math

You can also do math with numbers, and it'll work out pretty well:

    alert 1 + 2
    alert 5 - 3
    alert 2 * 3
    alert 4 / 2

But if you try this, nothing happens:

    alert "hey" + 2

This is kind of fun and silly, though:

    alert "hey" * 2

### Errors

You know how nothing happened when you hit the Run button earlier? That was
because there was an error. You can see any errors that run by hitting either
Alt-/ or Command-/, depending on what kind of computer you're using.

The error that results from `alert "hey" + 2` is 

    can't convert Fixnum into String

What is that?

## A few words about types

### Why's it do that?

Each part of a Ruby program is an `Object`. Right now, all you need to know
about `Object`s is that it's sort of like saying "a thing." Your program is made
up of a bunch of `Object`s working together.

We'll learn more about `Object`s in a future lesson, but there is one thing I'll
tell you: `Object`s have a 'type.' This lets Ruby know what kind of `Object` it
is.

### Adding numbers to words

That's why

    alert "hey" + 2

doesn't really work: "hey" is a `String` object, and 2 is a `Fixnum` object. And
adding `String`s and `Fixnum`s doesn't make any sense. We can make this code
work, though!

All we need to do is turn the `Fixnum` into a `String`. We can do this by using
the `to_s` method.

    alert "hey" + 2.to_s

### Let's look at that again

    alert "hey" + 2.to_s

Okay, this isn't bad. We have our `alert` method. We're giving it `"hey" +
2.to_s`. The `2.to_s` turns a `Fixnum` 2, which is like the mathematical idea of
a 2, into the `String` 2, which is like when you write a 2 down on a piece of
paper.

## Variables

### They're like boxes

What happens if we want to keep something around? Most programs are not one
line, I assure you. You can use a _variable_ to hold a value and use it later.
It's like a box that you put things in.

Let's try one out:

    message = "Hello, world!"
    alert message

Give that a run.

### Assignment

Cool stuff! We used an `=` to _assign_ the `String`"Hello, world!" into the
variable `message`. We then passed that `message` to the `alert` method.

As you can see, we can use variables in place of another value. Try this:

    number = 5
    number = number * 2
    number = number - 8
    number = number + 1
    alert number

Make a guess before you run this program.

## User Input

### ask-ing for it.

We can ask the user of our program for some input, and then put their answer
into a variable. It's easy! Check this program out:

    name = ask "What is your name?"
    alert "Hello, " + name

The `ask` method brings up a box and lets our users type something in. Fun! We
put their answer into the `name` variable and then showed it with `alert`.
Sweet!

## Basic flow control

### if...

Remember back to that Beginning Programming lesson... we talked about how
programs are one big list, that the computer follows in order.

Well, guess what? We can actually change this order by using certain bits of
code. Compare these two programs:

    number = 2
    if number == 2
      alert "Yes!"
    else
      alert "No!"
    end

    number = 1
    if number == 2
      alert "Yes!"
    else
      alert "No!"
    end

There are a few new things here.

### ==

Here it is again:

    number = 2
    if number == 2
      alert "Yes!"
    else
      alert "No!"
    end

The == command is just a bit different than the = command. == tests the `Object`
on its right against the `Object` on its left. If the two are equal, then the
code after the `if` will run. If they're not equal, you get the code after the
`else`. The `end` lets us know we're done with our `if`.

## Example: a guessing game

### Guess!

Let's put this all together:

```
secret_number = 42.to_s
guess = ask "I have a secret number. Take a guess, see if you can figure it out!"
if guess == secret_number
  alert "Yes! You guessed right!"
else
  alert "Sorry, you'll have to try again."
end
```

Can you guess what `to_s` does, and why you need it? If you're stumped, try
asking [on the Hackety Hack site](http://hackety-hack.com/stream) and we'll give
you a hand.

## Summary

### Good job!

Congrats! You've picked up all of the basics of Ruby. There's a lot more you
still have to learn, though!

Here's what you've learned so far:

`alert` and `ask`

`=`, variables, and `==`

`if` and `else`

Awesome! You'll want to check out Basic Shoes next!
