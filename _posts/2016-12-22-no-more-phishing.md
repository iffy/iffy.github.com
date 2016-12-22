---
title: No more phishing!
layout: post
image: /images/fishhook.jpg
---

<img src="/images/fishhook.jpg">

The Internet isn't fair to old folks.  I'm moderately tech-savvy and still not always sure if I'm secure online.  But watching older people use the Internet is sometimes terrifying.  It's a security minefield.

And here's the scariest part: one day, *I* will be old.  I'd really like it to be easier to be secure online.


## Phishing: The Goal

Phishing (when a person is tricked into divulging credentials or other authenticating information) is just one of the traps awaiting our parents and grandparents (and our future selves).  It would be nice if security novices:

1. could easily detect phishing attempts and
2. were not be susceptible to phishing attempts in the first place.

I want to build a phishing-resistant authentication system (because I'm not sure a phishing-*proof* system is practical).  Let's ground it in this real world scenario:

<div style="padding: 1rem 2rem; margin: 1rem 0; background-color: bisque;">
Great Aunt Alice wants to access her Bob the Bank account through the tablet her grandchildren gave her.  Nefarious Nellie wants to steal Great Aunt Alice's credentials.
</div>

A phishing-resistant authentication system should have these qualities:

1. Alice should know when she's browsing the legitimate Bank's website.
2. More importantly, Alice should know when she's NOT browsing the legitimate bank's website.
3. Bob the Bank should be able to authenticate Alice.
4. The fewer credentials Alice has to manually provide, the simpler the system, the more likely she is to get it right.
5. Credential/authentication recovery should be of equal or greater security than the day-to-day authentication system.
6. Nefarious Nellie should think it too hard to even trying phishing Alice.


## Authentication Basics

To prove who you are to someone, there are:

1. things you know (e.g. passwords, PINs)
2. things you have (e.g. door key, private key)
3. things you are (e.g. DNA, fingerprint) <-- you could argue that this is the same as "things you have."
4. trusted "friends" (e.g. your friend Sam knows the bouncer, or SSL certificate chains)
5. things [you did last summer](https://www.youtube.com/watch?v=yRWfc-8wLm4)

Let's apply these basics to secure Aunt Alice's account.

## A possible solution

Imagine there's a device.  It needs a name... we'll call it Device.  Great, we're off to a good start.

The Device can communicate over the Internet *and* with nearby web browsers.

### Setup

The Device must authenticate Alice in some way every time it's unlocked for use&mdash;perhaps through a PIN *chosen by the Device.*

### First Contact

Alice first needs to link the Device and her tablet's web browser.  This linking could be done with the Device scanning a QR code or Bluetooth or some other means.  Once linked, the browser and Device remember each other.  It's important to note that the Device isn't linked to a particular *website* but to the installed, running browser.

### Sign up

Then, for Alice to sign up with Bob the Bank using Device:

1. she scans a Bank-provided QR code with Device's camera
2. the Device establishes secure communication with Bob the Bank (whether that's through key exchange or some other means...)
3. the Device, Alice's browser and Bob the Bank do a three-way dance to establish authenticity between Alice's browser and Bob the Bank

If Alice is trying to sign in to the Bank for an account she already has, the Bank will provide an out-of-band (in person/in the mail) one-time use code to associate this Device with her existing account.

The Device will prominently show what she's signed in to, with an easy way to sign out.  Something like:

<style>
.device {
    max-width: 3in;
    margin: 1rem auto 2rem;
    box-shadow: 0px 0px 6px 3px rgba(0,0,0,0.2);
}
.item {
    padding: 0.5rem;
    border: 1px solid black;
    border-width: 0 1px 1px 1px;
}
.item:first-child {
    border-top-width: 1px;
}
.item .title {
    font-weight: bold;
}
.item.in-use {
    background-color: rgba(39, 174, 96, 0.5);
}
.item .status {
    padding-left: 1rem;
}
</style>

<div class="device">
    <div class="item in-use">
        <div class="title">Bob the Bank</div>
        <div class="status">
            You are signed in on <i>Home Tablet</i>
            <br/><button>Click here to sign out</button>
        </div>
    </div>
    <div class="item">
        <div class="title">Facebook</div>
        <div class="status">You are signed out</div>
    </div>
    <div class="item">
        <div class="title">Email Inc.</div>
        <div class="status">You are signed out</div>
    </div>
</div>

### Sign in

When Alice wants to sign in to Bob the Bank again, she browses to the bank website.  The browser detects that the bank supports Device authentication, and directs Alice to unlock the device to gain access to her account.  The same three-way dance is done to authenticate Alice's browser and Bob the Bank. 

### GPS

The Device may be equipped with GPS and be deactivated/or emit notifications when it leaves a fenced area.

### Family and Friends

None of the above is really all that novel.  If you have a working device and knowledge of the PIN, things work pretty well.  It's the recovery cases of an authentication scheme that are tricky.  For instance, if Alice:

- forgets her PIN
- loses her Device
- has her Device stolen
- breaks her Device

and you have crummy recovery options like, "Please tell us your mother's maiden name:" then an attacker will just attack the recovery route.

So here's something semi-novel: link Devices between people you already trust in real life.  If Alice had a device that was synced to her Nephew Tommy's Device and her Daughter Janice's Device, then she could ask Janice or Tommy to help recover/reset her PIN.  Same for remotely disabling a device.  And Alice could even have Tommy and Janice be notified whenever she signs up for another service.

## Analysis

So, how well does this proposed solution meet the criteria from above?  Foremost, Alice only knows one thing: a PIN.  And the PIN is only useful if you have the Device in your hand.  Even if she accidentally divulges her PIN over the phone or online, it's worthless.

### 1. Alice should know when she's browsing the legitimate Bank's website.

When Alice visits the known site, she enters her PIN on the Device and is signed in.

### 2. More importantly, Alice should know when she's NOT browsing the legitimate bank's website.

When Alice visits Nellie's phishing site, the browser knowns that it's a different website and won't divulge the credentials.  To Alice, it will look like she's signing up for a new website.  And if Alice is synced with Tommy and Janice, they'll be notified if she does sign up.

### 3. Bob the Bank should be able to authenticate Alice.

The Device and Bob the Bank both authenticate each other.

### 4. The fewer credentials Alice has to manually provide, the simpler the system, the more likely she is to get it right.

She only knows one credential (her PIN) and it's only useful if you possess the device.

### 5. Credential/authentication recovery should be of equal or greater security than the day-to-day authentication system.

It's hard to do better than relying on social/familial trust instead of "what you know" or "what you have."  Of course, this can also be hacked.  But for the old folks in my life, this would be a stunning improvement and pretty darn secure.

### 6. Nefarious Nellie should think it too hard to even trying phishing Alice.

Nefarious Nellie would spend her time trying to steal the Device and PIN because Alice doesn't possess any passwords.


## What it would take

Both browsers and servers would need to know how to speak to Devices.  Ideally, the browser-Device communication would be built-in to the browser and *NOT* be an extension.

Companies would have to make the devices and be willing to let them run independently (without a subscription or central server).  Maybe an open source model would work well for this.

There probably needs to be some always-on infrastructure that facilitates the peer-to-peer syncing of Devices.

## Conclusion

This is the conclusion (hence the subheading).  Thoughts/comments/questions welcome.

