---
title: River Crossing Riddle
layout: post
image: /images/river/lion.png
---

The river crossing riddle is described in this video (it's okay to play it, it will probably stop before revealing the solution):


<iframe width="500" height="300" src="https://www.youtube.com/embed/ADR7dUoVh_c?start=6&end=60" frameborder="0" allowfullscreen></iframe>

The rules (from the last part of that video):

1. The raft needs at least one animal to paddle it across the river, and it can hold at most two animals.
2. If the lions ever outnumber the wildebeest on either side of the river (including the animals in the boat if it's on that side), they'll eat the wildebeest.
3. The animals can't just swim across, and there are no tricks; the animals have to use the boat as described.

I wanted to figure it out, so I made a simulation.  And I chose this particular lion picture because I'm pretty sure it's the lion picture my daughters would choose:

<style>
.game {
  display: flex;
  width: 100%;
  justify-content: center;
  align-items: stretch;
  min-height: 1rem;
  border-radius: 3px;
  overflow: hidden;
  position: relative;
}
.game > div {
  padding: 1rem;
}
.ground {
  background-color: rgb(82, 51, 25);
  width: 10rem;
}
.water {
  background-color: #3498db;
  flex-grow: 2;
  position: relative;
}
.lion {
  width: 10rem;
  height: 7rem;
  background-image: url(/images/river/lion.svg);
  background-repeat: no-repeat;
  transition: left 0.5s, top 0.5s;
}
.boat {
  width: 10rem;
  height: 5rem;
  background-position: bottom right;
  background-image: url(/images/river/boat.svg);
  background-repeat: no-repeat;
  background-size: cover;
  transition: left 0.5s, top 0.5s;
  display: flex;
  flex-wrap: nowrap;
  position: absolute;
  top: 10rem;
}
.boat.left {
  left: 0;
}
.boat.right {
  right: 0;
}
.beast {
  width: 10rem;
  height: 7rem;
  background-image: url(/images/river/antelope.png);
  background-repeat: no-repeat;
  background-size: contain;
  transition: left 0.5s, top 0.5s;
}
.boat .thing {
  width: 5rem;
  height: 3.5rem;
}
.game .banner {
  position: absolute;
  top: 2rem;
  left: 0;
  text-align: center;
  width: 100%;
  background-color: rgba(52, 152, 219, 0.9);
  color: white;
  font-size: 2rem;
  font-weight: bold;
}
.game .banner.lose {
  background-color: rgba(231, 76, 60, 0.95);
}
</style>

<button id="reset-btn">Reset</button> Moves: <span id="move-counter"></span>

<div class="game">
  <div class="left ground">
    <div class="lion thing"></div>
    <div class="beast thing"></div>
    <div class="lion thing"></div>
    <div class="beast thing"></div>
    <div class="lion thing"></div>
    <div class="beast thing"></div>
  </div>
  <div class="water">
    <div class="boat left"></div>
  </div>
  <div class="right ground"></div>
  <div class="banner"></div>
</div>

<div id="move-script"></div>

<script>
$(function() {
  var boat_side = 'left';
  var boat = $('.boat');
  var lside = $('.left.ground');
  var rside = $('.right.ground');
  var playing = true;
  var won = false;
  var banner = $('.banner');
  var moves = [];

  function reset() {
    playing = true;
    var things = $('.lion, .beast');
    things.clone().appendTo(lside);
    things.remove();
    boat.addClass('left').removeClass('right');
    banner.removeClass('lose').hide();
    moves.length = 0;
    $('#move-counter').text(moves.length);
    $('#move-script').text();
  }

  $('#reset-btn').click(function() {
    reset();
  })

  $(document).on('click', '.lion, .beast', function(ev) {
    clickedPlayer($(ev.target));
  });
  $('.boat').click(function(ev) {
    if (!playing) {
      return;
    }
    if ($(ev.target).hasClass('thing')) {
      // actually clicked inside the boat
      clickedPlayer($(ev.target));
      return false;
    } else {
      // clicked boat
      if (boat.children().length === 0) {
        // no one to drive
        return
      }
      if (boat.hasClass('left')) {
        boat.removeClass('left').addClass('right');
        recordMove('row across the river');
      } else {
        boat.removeClass('right').addClass('left');
        recordMove('float back');
      }
      checkForWinLoss();
    }
  });
  function recordMove(move) {
    if (moves.length === 0) {
      $('#move-script').text('You ');
    } else {
    }
    moves.push(move);
    $('#move-counter').text(moves.length);
    $('#move-script').append($('<span>').text(move + ', '));
  }

  function clickedPlayer(elem) {
    if (!playing) {
      return;
    }
    var animal = elem.hasClass('lion') ? 'lion' : 'beast';
    if (elem.parent().hasClass('boat')) {
      // on the boat
      var num_same = $('.boat .' + animal).length;
      removeFromBoat(elem);

      var article = 'a';
      if (num_same === 1) {
        article = 'the';
      }
      recordMove(['let', article, animal, 'off'].join(' '));
    } else {
      addToBoat(elem);
    }
    checkForWinLoss();
  }
  function addToBoat(elem) {
    // is the boat full?
    if (boat.children().length >= 2) {
      // boat is full
      return;
    }
    // is the boat on the correct side
    var elem_side = elem.parent().hasClass('left') ? 'left' : 'right';
    if (!boat.hasClass(elem_side)) {
      // boat is on the other side
      return;
    }

    var animal = elem.hasClass('lion') ? 'lion' : 'beast';
    var num_same = $('.ground.' + elem_side + ' .' + animal).length;
    var num_on_boat = $('.boat .' + animal).length;

    boat.append(elem.clone());
    elem.remove();

    var article = 'a';
    if (num_on_boat) {
      article = 'another';
    } else if (num_same === 1) {
      article = 'the';
    }
    recordMove(['put', article, animal, 'on the boat'].join(' '));
  }
  function removeFromBoat(elem) {
    var side = boat.hasClass('left') ? lside : rside;
    side.append(elem.clone());
    elem.remove();
  }
  function checkForWinLoss() {
    var left_lions = $('.left .lion').length;
    var right_lions = 3 - left_lions;
    var left_beasts = $('.left .beast').length;
    var right_beasts = 3 - left_beasts;
    if ((left_beasts && (left_lions > left_beasts)) || (right_beasts && (right_lions > right_beasts))) {
      loseGame();
    } else if (left_lions === 0 && left_beasts === 0) {
      winGame();
    }
  }
  function loseGame() {
    playing = false;
    won = false;
    banner.addClass('lose').text('Nom, nom, nom...').show();
    $('#move-script').append(' and then let the lions feast!  Oops.');
  }
  function winGame() {
    playing = false;
    won = true;
    banner.removeClass('lose').text('You WIN!').show();
    $('#move-script').append(' and then you win!');
  }
  reset();
})
</script>