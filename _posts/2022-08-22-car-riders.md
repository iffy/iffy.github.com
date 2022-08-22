---
layout: post
title: Making Car Rider Lines Faster
# tags:
# - art
# image:
---

As I sit in the car rider line for our children’s school, I find myself capable of thinking only one thing: can’t we make this blasted line move any faster?!! I’ve considered all kinds of improvements to speed things along. But instead of relying on my own intuition, like any good nerd, I instead built an elaborate simulation engine to answer the question:

How do we make car rider lines better?

I think the answer might surprise you.

## Introduction

If you haven’t experienced a school car rider line, thank your lucky stars. Here is the simplest (and worst) possible car rider line:

<iframe src="/images/carrider/carrider.html?arg=--height&arg=3&arg=--noeditor&arg=--map&arg=%7B%22d%22%3A%2200000000000005000000000000001222222222222322222222222227%22%2C%22x%22%3A%5B%5D%7D" width="100%" height="128"></iframe>

Cars pull up to the school, wait, inch forward, wait, inch forward, wait, inch forward, drop off the children cooped up inside, then drive away. Simple.

Here’s a more realistic car rider line:

<iframe src="/images/carrider/carrider.html?arg=--noeditor&arg=--speed&arg=5&arg=--pause&arg=--map&arg=%7B%22d%22%3A%2210222220222022222222222222222020002020202000000000000002202200202020202220222022222220020020202220202020202000002002002020000020202020222222202202202202222022202000000220200200020200000000202222222020020222022222220220200000202202020000000002020022222220020202022222220202000000022022020202000002020202220002202002020200050222022202222220200202020004000000000000002022020202022322222222222222200202020202000000000000000220220202020222222222222222022020020202000000000000000202202202020222222222222222220220020202000000000000000000022022020222222222222222222202202002000000000000000000020220220222222222202222222202022002000000000020200000020202202202222202222022222202020220200200020200000000020202022022220002020222022202020202200000000202020202020202020222222222220222022202220222070000000000000000000000000000%22%2C%22x%22%3A%5B%5D%7D" width="512" height="512"></iframe>

At least, that’s what it feels like.

## Simulation details

Real quick, for these simulations, the red school building (in the middle) shows the number of students arriving per time. Higher is better.

The number where cars exit (on the right) shows the average time cars spent waiting. Lower is better.

Cars carry between 1 and 2 kids to school and drive/stop/wait at random rates.

Pause/play with `P`. Also you can speed up the simulation by pressing `]`, or slow it down with `[`.

Okay, back to making car rider lines faster!

## Longer dropoff zone

It’s silly to have only one car dropping kids off at a time, so let’s extend that dropoff zone to let more kids get to their educational duties at once.

<iframe src="/images/carrider/carrider.html?arg=--height&arg=3&arg=--noeditor&arg=--speed&arg=5&arg=--map&arg=%7B%22d%22%3A%2200000000000005000000000000001222222222223332222222222227%22%2C%22x%22%3A%5B%5D%7D" width="100%" height="128"></iframe>

Grouping cars like this is a big improvement though it comes at the cost of needing more coordination so that cars don’t stop too early in the zone and waste space.

Oh, and so kids don't get run over.

But, what happens where there are more cars coming at once?  Because it is law that *all* parents arrive at the car rider line at the same time.

<iframe src="/images/carrider/carrider.html?arg=--height&arg=7&arg=--noeditor&arg=--speed&arg=5&arg=--map&arg=%7B%22d%22%3A%2212222222000000000000000000000000000200000000000000000000122222220000000000050000000000000002222222222233322222271222222200000000000000000000000000020000000000000000000012222222%22%2C%22x%22%3A%5B%5D%7D" width="100%" height="128"></iframe>

This doesn't work so well.

## Sequential vs Parallel

Instead of having only one long dropoff zone, then how about making more parallel zones?

<iframe src="/images/carrider/carrider.html?arg=--height&arg=7&arg=--noeditor&arg=--speed&arg=5&arg=--map&arg=%7B%22d%22%3A%2212222222000000000000000000000000000200022222223332220000122222220002000000454002000000000002222222222233322222271222222200020000004440020000000000020002222222333222000012222222%22%2C%22x%22%3A%5B%5D%7D" width="100%" height="128"></iframe>

Great! If grouping dropoffs makes it better, and having parallel dropoffs makes improves it more, then here is the optimal car rider dropoff plan!

(Click on it and press `P` to watch it go)

<iframe src="/images/carrider/carrider.html?arg=--noeditor&arg=--speed&arg=5&arg=--pause&arg=--map&arg=%7B%22d%22%3A%22122222233333333333333333322700000004444444444444444440000000000000000400000000000000122222233333333333333333322700000004444444444444444440000000000000000400000000000000122222233333333333333333322700000004444444444444444440000000000000000400000000000000000000000000050000000000000000000004444444444444444440001222222333333333333333333227000000000000040000000000000000000004444444444444444440001222222333333333333333333227000000000000040000000000000000000004444444444444444440001222222333333333333333333227000000000000040000000000000000000004444444444444444440001222222333333333333333333227000000000000040000000000000000000004444444444444444440001222222333333333333333333227000000000000040000000000000000000004444444444444444440001222222333333333333333333227%22%2C%22x%22%3A%5B%5D%7D" width="512" height="512"></iframe>

Bam! This works way better than the sequential line, but at the cost of a LOT more roads, a LOT more walking for the kids and a LOT more opportunity for kids to get run over. This clearly won’t work, because kids don’t like walking. Sometimes, they’d rather get run over than have to walk at all. They’ll gladly run 5 miles for fun, but... I digress.

I should mention at this point that kids in the simulation start out walking fast, but quickly get tired and slow down.

The kids crossing in front of the cars really delays the cars.

## Multiple, farther away dropoff spots

It seems like a big part of the problem is that we're trying to get a whole bunch of people all to the same place at once. What if, instead of having every car come to the same place, we had them go to different places and let the kids walk? Like this:

<iframe src="/images/carrider/carrider.html?arg=--noeditor&arg=--speed&arg=5&arg=--pause&arg=--map&arg=%7B%22d%22%3A%2212220001000070700001000000000003400200002020000200002221000340020000202000020004300000034002333320233332000430000003444444440004444004443000722200000004000040000404300000000000000400004000040022270000000000040000400444000000000000000004000040040000222112220000000400004004000430000003000000040000400400043000000344444444444444444444300000030000000050000040000430000003000044444000004000002227722200044000444444444440000000000044000040000000004000001222044000444000222220400000000344000040000030002044222700034000004000003000200030000003400000444444300020003000000340022240400030002000300000020002034040002220200030007222000203404000002020002221000000020340400000202000000000000002034040000020200000000000000202004444002020000000000000020202333320202000000000000001070100007010700000000000000000000000000000000000%22%2C%22x%22%3A%5B%5D%7D" width="512" height="512"></iframe>

Wow, this works *really* well! Cars don't have to wait hardly at all! Surely *this* is the optimal car rider line.

Unfortunately, children must always walk a *shorter* distance to school than their grandparents. Otherwise the grandparents couldn't tell them that in their day they walked N+1 miles to school. The above method would require too much walking and thus break the pattern.

So what if, instead of having the kids walk, we deploy shuttles of some kind?

## Shuttles

Here's the same scenario from above, but with shuttles driving the kids from the shuttle drop-off locations to the school. To distinguish them from cars, I've randomly chosen to color the shuttles yellow and make them longer.

<iframe src="/images/carrider/carrider.html?arg=--noeditor&arg=--speed&arg=5&arg=--pause&arg=--map&arg=%7B%22d%22%3A%2212220001000070700001000000000003400200002020000200002221000340020000202000020004300000034002333320233332000430000003444444440004444000043000722206222262202262222264300000000200000020200000002022270000020000002020000000200000000002000000202000000020222112220200000020200000002430000003462222226020000000643000000300000000402000000024300000030000000050200000002430000003022222644460000000202227722202000200402222222260000000000200020262000000004000001222020002020200222220400000000346222202022030002044222700034000000200603000200030000003400000460024300020003000000340022242002030002000300000020002034200202220200030007222000203420020002020002221000000020342002000202000000000000002034262200020200000000000000202004444002020000000000000020202333320202000000000000001070100007010700000000000000000000000000000000000%22%2C%22x%22%3A%5B%5D%7D" width="512" height="512"></iframe>

That works *really, *really* well.

## I am the problem

I'll admit, after many mornings and afternoons of contemplating this problem, I laughed out loud when I realized that busses are the solution.

Well, busses are the *technical* solution. That people don't use the technical solution means that it's really a people/psychological/behavioral problem.

Astute readers will notice that I've done all this work because I, myself, am stuck in the car rider line. Astute and judgmental readers will call me a hypocrite for complaining about being in line while advocating using the bus. Sadly, there is no bus stop near us. When we had one nearby, we used it and loved it. I'm sure there are others in my shoes.

But not 90% of people in the line, surely!

## Behavior

If the technical solution for speeding up the car rider line exists (it's busses), then how do we get people to use it (the busses)?

We could **pay people** to use the bus. I don't think this would work, though, because schools already claim to be low on funds. Secretly, we know that they spend all their money on chocolate milk for lunch.

Well then, instead of paying people, **charge them!** Imagine the revolt if we had to swipe our credit card every time we got in the sluggish car rider line. I can hear everyone now: "I'm paying 50¢ a day for *this*? I'd rather ride the bus!"

As well as it would work, unfortunately, the rich would end up paying for it and the poor would suffer disproportionately. And there would probably be legal battles, and such. It would be a mess.

We could erect **motivational signs** along the car rider line: "You could have been home by now if you used the bus" or "Tired of waiting? Try the bus!" or "Is this how you imagined using your Tesla?"  Maybe signs would work.

If we can't coerce people with money, and educational signs would have limited success, how else can we make the car rider line less desirable than the bus?

The answer is staring us in the face!

Make it worse!

Yes, that's right. If you want to make the car rider line better, make it worse. The worse it is, the fewer people will use it and the better it will be.

## Conclusion

Here, then is the optimal car rider line.

<iframe src="/images/carrider/carrider.html?arg=--height&arg=14&arg=--speed&arg=5&arg=--noeditor&arg=--map&arg=%7B%22d%22%3A%2200000700010010007070001000001220023332002333202333200000003400444000044400444400000000346226000000622260000000000034200200000020002000000000722020020000002000202222222000002002000000200024300000211220200200000020002430000000003462260000002000243000000000340004445444622264222222270034000000400000000000000000722000000040000000000000000000000000004000000000000000001222222222322222222222222227%22%2C%22x%22%3A%5B%5D%7D" width="100%" height="400"></iframe>


## Play time

If you want to play around with the simulator, this one has the editor enabled.

- `E` go to edit mode
- `Escape` quit edit mode
- When in edit mode, the keys `1`-`7` will place different tiles.
- `Backspace` deletes
- `C` will clear it out
- Make crosswalks by putting down a road then putting sidewalk over it
- There are all kinds of bugs

<iframe src="/images/carrider/carrider.html?arg=--pause" width="512" height="512"></iframe>

But seriously, administrators, spend money on the busses, not "improving" the car rider lines.
