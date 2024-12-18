import Image from "next/image";
import React from "react";

function Hero() {
  return (
    <div className="pt-20 mx-8 flex">
      <div className="flex flex-col justify-center font-[family-name:var(--font-montserrat)] font-bold mt-32">
        <h1 className="text-titles text-[40px]">
          Effortles Bounty Distribution,
        </h1>
        <h1 className="w-[95%] text-[40px] font-semibold">
          Where Hackathons Ninjas Earn & Gain Their Treasure.
        </h1>
        <p className="text-subtitles font-light mt-4 text-[16px] w-[95%]">
          At Hackathon Solutions, we simplify post-hackathon reward management.
          Whether you are organizing a global event or a local sprint, our
          platform ensures bounties are distributed fairly, quickly, and with
          precision.
        </p>
        <div className="flex items-center gap-4 mt-12">
          <button className="rounded-[3px] bg-black text-white px-4 py-3 mt-4">
            Host a Hackathon
          </button>
          <button className="rounded-[3px] bg-[#e6f2ff] text-brand px-4 py-3 mt-4">
            View White Paper
          </button>
        </div>
      </div>
      <div className="w-[80%]">
        <Image
          src="/hero.svg"
          width={500}
          height={500}
          alt="hero"
          className="w-full h-full mt-6"
        />
      </div>
      <Image
        src="/floating-hero-top.svg"
        width={70}
        height={70}
        alt="star"
        className="absolute top-[22%] left-4"
      />
    </div>
  );
}

export default Hero;
