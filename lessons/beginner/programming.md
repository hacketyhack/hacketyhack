# Beginner Programming

## Hello there!

### Round One

So, you'd like to learn how to hack code with the best of 'em, eh? Well, you've
come to the right place. This is the very first lesson I have to share with you.
It all starts here.

I want to get you started off on the best possible foot with making programs, so
we'll start off by talking a little bit about what programming is, and then
we'll write some basic programs to draw fun things on the screen. Sound good?
Off we go!

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

## Let's talk about programming

### It's all about instructions

When you get down to it, programming is all about __algorithms__. That's a big
fancy word for 'a list of instructions.' Every program is simply a big to-do
list of instructions for the computer to follow.

You can turn almost anything into a list of instructions if you really think
about it. Most of the time, you've got so much practice at doing things that you
don't even think about these individual steps. You just do them. It's very
natural.

### The computer is simple

Unfortunately, computers are actually quite simple. This may be contrary to
everything you've ever heard, but it's the truth. Even though we compare
computers to things like our brains, it's a really poor analogy. What computers
are actually really good at is performing simple, boring things over and over
again very accurately. They can't think for themselves!

This is why computers appear to be complex. They blindly follow whatever orders
they're given, without any thought about how those instructions are good or bad.
It's hard to think in such simple terms!

### Explain yourself well

It's important to remember that you have to fully explain yourself to the
computer when you're programming. It can't figure out what you're trying to say,
so you have to say what you mean!

This takes some practice, so we're going to start off with some exercises in
explaining ourselves in very basic terms. It's almost like trying to explain
math to a young child: you have to go slowly, triple check your work, and have
some patience when it just doesn't quite get it.

## Lists of Instructions

### A to-do list, not a shopping list

When I say that computers follow lists of instructions, I mean a to-do list, not
a shopping list. What I'm trying to say is that these lists have an __order__ to
them that the computer follows. It does each step in turn as quickly as it
possibly can.

A shopping list is a different kind of list entirely. You can go to whichever
aisle you choose, and as long as you get everything before you leave, you're
A-OK. This isn't what the computer does at all.

### How would you tell a person to do it?

Let's try an example: if you had to tell someone in words how to draw a square
on a piece of paper, how would you do it?

You're not allowed to say "like this" or "this way," that's cheating! You have
to spell out every detail.

### Once again: computers are simple

How'd you do? I can't see what you said, but here's an example of how simple
computers are compared to people. Did you forget to mention how long each side
of the square is? If you didn't good job!

Here's how I'd do it, by the way. This isn't the only right answer, it's just an
example:

1. Put your pen down on the paper.
2. Draw right one inch.
3. Draw down one inch.
4. Draw left one inch.
5. Draw up one inch.
6. Take your pen off of the paper.
7. Finished!

## Turtles, all the way down.

### Drawing... with turtles?

Okay! Enough of these thinking experiments. Let's actually make something. I bet
you've been wondering when that was going to start, right? It's really important
to get the basics down first.

We're going to tell the computer how to draw shapes... with turtles. Yes, you
heard me right. You're going to have to give these instructions to a turtle.

This particular turtle is carrying a pen. You have a piece of paper. The turtle
will follow your every word. But the turtle is a bit slow, and needs careful
instruction. Are you up to it?

### The Turtle and its commands

We have to tell Hackety Hack that we want to tell the Turtle what to do. To do
that, we have a `Turtle` command. We can tell the `Turtle` two things: 

`draw`: the turtle will follow our instructions at lightning speed, 

`start`: an interactive window will appear, which lets you see the turtle move
at each step in the program. You can move at your own pace. This is useful if
the turtle isn't doing what you expect!

Click on the editor tab to get started:

![Not this one, silly! the one on the left!](static/tab-new.png)

### Type it in!

Cool. Now type this: 

    Turtle.draw

The period in between the `Turtle` and the `draw` connects them together.
Programming languages have rules, just like English has rules! You can think of
`Turtle` like a subject, and `draw` as a verb. Together, they make a sentence:
hey turtle, draw me something!

Once you've typed that in, go ahead and click the 'Run' button. The turtle moves
so quickly in `draw` mode that you won't even see him, but I assure you, he's
there!

### Do... what I tell you to

Awesome! We've got the turtle going, at least. Now we need to tell it what we
want to draw!

Remember when we said that all programs are lists of instructions? In this case,
our program only has one instruction: `Turtle`, draw something! But we need to
be able to give the `Turtle` its own list of instructions.

To do this, we'll use two words: `do` and `end`. These two words together make
up a _sublist_ of things, just for the `Turtle`!

### Changing the background

Let's try this: we can tell the `Turtle` that we want to use a different
background color by using the `background` command. Check it out:

    Turtle.draw do
      background maroon
    end

Type this in and click 'Run'!

### The Turtle gets its orders

Cool stuff! The background is now maroon. You can find a full list of colors
that are supported on the [Shoes
website](http://shoesrb.com/manual/Colors.html).

This is also how you make lists of instructions for the `Turtle` to follow. To
make it a little easier to see, programmers will often put two spaces before
sublists. Get in the habit now, you'll thank me later!

### The pen

Now that we've got a snazzy background color, how do we draw some lines? Well,
the first thing you need to know about is the pen. The `Turtle` carries a pen
along, and drags it along the ground behind itself. You can change the color of
line the pen draws with the `pencolor` command.

## Drawing lines

### Sally forth!

Okay, enough dilly-dallying. Let's tell the turtle to draw a line! Here's my
line. Give this one a shot, then try your own colors and numbers!

    Turtle.draw do
      background lightslategray
      pencolor honeydew
      forward 50
    end

50 is the number of pixels to move foward, by the way.

### You spin me right round, baby

Great! So you've got a line. But what if you don't want the `Turtle` to move
forward? Well, you can tell it to turn by using a `turnleft` or `turnright`
command, like this:

    Turtle.draw do
      background lightslategray
      pencolor honeydew
      forward 50
      turnright 90
      forward 50
    end

Give that a shot, then play with it a bit!

If you're wondering what 90 means, it's the number of degrees that it'll turn.

### I like to move it, move it

Okay, now we're cooking! Let's break this down again:

`Turtle.draw` tells the `Turtle` we want it to draw some things. The period
connects the two.

`do ... end` is a sublist of things. This is what we want the `Turtle` to be
drawing. Not for the rest of our program.

`pencolor` sets the color of the pen the `Turtle` is dragging along behind him,
and `background` sets the color of the background.

`turnright` (or its buddy `turnleft`) tells the `Turtle` to turn to the right or
left.

`forward` (or its friend `backward`) tells the `Turtle` to move.

### Let's try drawing that square

Go ahead. Give it a shot. Try to get the `Turtle` to draw a square.

I'll wait. :)

### Here's my version

Here's how I did it:

    Turtle.draw do
      background lightslategray
      pencolor honeydew
      forward 50
      turnright 90
      forward 50
      turnright 90
      forward 50
      turnright 90
      forward 50
    end

## Repeating ourselves

### Pete and Repeat...

Man, that was a ton of reptition! My fingers almost fell off typing `forward`
and `turnright` there!

I have good news, though: I mentioned something earlier about computers. It
turns out that doing boring, repetitive things is something they're really good
at! They'll do the same thing over and over again, forever even as long as you
ask nicely.

### Repeating repeating ourselves ourselves

Check it out: our `Turtle` actually knows numbers. For example:

    Turtle.draw do
      background lightslategray
      pencolor honeydew
      4.times do
        forward 50
        turnright 90
      end
    end

Try running this example. It also draws a square! Wow!

### 4.times

It's pretty easy: `4` can take instructions too, just like our `Turtle`. This
command repeats a list of instructions that many times. Fun! Four times. And the
`do` and `end` show which list of instructions go with the `4` rather than with
the `Turtle`.

### Try it out!

Have a blast: make some fun shapes of your own!

## Summary

### Congratulations!

Wow, you're awesome. Pat yourself on the back. High five someone. You've got
these basics down!

Check out the _Basic Ruby_ lesson to pick up some totally different and exciting
things!
