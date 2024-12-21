import Image from "next/image";
import React from "react";

function CTA() {
  return (
    <div className="flex relative flex-col justify-center font-[family-name:var(--font-montserrat)] font-bold mt-32 mx-8">
      <div className="leading-relaxed">
        <h1 className="w-full text-[40px] font-semibold text-titles">
          Join the Hackathon Revolution
        </h1>
        <h1 className="w-full lg:text-[40px] md:text-[30px] font-semibold">
          Take the stress out of post-event management. We empower organizers to
          focus on innovation while we handle the heavy lifting. Be the Ninja
          your participants deserve.
        </h1>
      </div>
      <div className="flex gap-8 mt-4">
        <div className="lg:max-w-[720px] w-full">
          <p className="text-gray-700 lg:text-[16px] md:text-[13px] mt-8 font-light mb-8">
            Whether you are running a weekend sprint or an international
            competition, Hackathon Solutions ensures that every winner feels
            valued and every moment counts. Our innovative platform is not just
            a tool; it is a game-changer for hackathon communities worldwide.
          </p>
          <p className="text-gray-700 lg:text-[16px] md:text-[13px] mt-8 font-light mb-8">
            It is time to revolutionize how you manage your hackathons.
          </p>
          <p className="text-gray-700 lg:text-[16px] md:text-[13px] mt-8 font-light mb-8">
            ake the first step—be part of the movement that redefines hackathons
            for organizers and participants alike
          </p>
          <div className="flex items-center gap-8 mt-16">
            <button className="bg-[#000000] text-[#fff] font-semibold text-[16px] w-[170px] h-[45px] flex items-center justify-center  rounded-lg hover:shadow-lg duration-300 ease-out transition-all">
              Host a Hackathon
            </button>

            <button className="bg-[#E6F2FF] text-brand font-semibold text-[16px]  w-[170px] h-[45px] flex items-center justify-center  rounded-lg hover:shadow-lg duration-300 ease-out transition-all">
              View Whitepaper
            </button>
          </div>
        </div>
        <Image
          src="/hero.svg"
          alt="hero"
          width={500}
          height={500}
          className="lg:ml-16"
        />
      </div>

      <Image
        src="/floating-hero-top.svg"
        width={70}
        height={70}
        alt="star"
        className="absolute -top-10 left-0"
      />
      <Image
        src="/ribbon-blue.svg"
        width={70}
        height={70}
        alt="star2"
        className="absolute top-1/4 left-0 opacity-50"
      />
      <Image
        src="/ribbon-green.svg"
        width={70}
        height={70}
        alt="star3"
        className="absolute -top-8 right-1/4"
      />
      <Image
        src="/ribbon-blue.svg"
        width={70}
        height={70}
        alt="star2"
        className="absolute -top-8  right-0 opacity-100"
      />
    </div>
  );
}

export default CTA;
