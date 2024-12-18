import Image from "next/image";
import React from "react";
import { BrandHeader } from "./Navbar";

const features = [
  {
    id: 1,
    title: "Transparent Process",
    content:
      "Trust is the backbone of any successful hackathon, and transparency is key to building it. Hackathon Solutions provides a clear, detailed breakdown of how rewards are calculated and distributed.",
    icon: "/transparent.svg",
  },
  {
    id: 2,
    title: "Secure Transactions",
    content:
      "Security is non-negotiable. Hackathon Solutions is built with advanced encryption and blockchain-inspired tracking systems to protect your data and funds.",
    icon: "/secure.svg",
  },
  {
    id: 3,
    title: "Customizable Rewards",
    content:
      "No two hackathons are alike, and your reward structure should reflect that. Hackathon Solutions provides complete flexibility to configure payouts based on your event’s unique needs.",
    icon: "/customizable.svg",
  },
  {
    id: 4,
    title: "Swift & Seamless Payouts",
    content:
      "Like a ninja in the shadows, Hackathon Solutions ensures that bounty payouts are handled with speed and precision. Our automated system eliminates manual errors and delays, delivering rewards to participants in record time.",
    icon: "/swift.svg",
  },
];

function Features() {
  return (
    <div className="flex flex-col justify-center font-[family-name:var(--font-montserrat)] font-bold mt-32 mx-8">
      <h1 className="text-titles text-[40px]">Why Hackathon Solutions?</h1>
      <h1 className="w-full text-[40px] font-semibold">
        Hackathon Solutions comes in—a platform designed to make
      </h1>
      <h1 className="w-full text-[40px] font-semibold">
        {" "}
        your post-event process effortless, transparent, and efficient.
      </h1>
      <p className="text-gray-700 text-[16px] mt-4 font-light mb-8">
        At Hackathon Solutions, we simplify post-hackathon reward management.
        Whether you are organizing a global event or a local sprint, our
        platform ensures bounties are distributed fairly, quickly, and with
        precision.
      </p>
      <div className="grid grid-cols-2 md:grid-cols-2 gap-8 mt-12 max-w-7xl mx-auto my-0">
        {features.map((feature) => (
          <div
            key={feature.id}
            className={`flex group/item gap-2 items-center space-y-2 space-x-2 opacity-80 hover:opacity-100 w-[560px] h-[220px] shadow-lg p-4 rounded-lg hover:shadow-xl duration-300 ease-out transition-all cursor-pointer`}
            style={{
              backgroundImage: `url("/background-image.jpeg")`,
              backgroundSize: "contain",
              backgroundColor: `${
                feature.id === 4
                  ? "rgb(199, 188, 234)"
                  : "rgba(255,255,255,0.8)"
              }`,
              backgroundBlendMode: `${feature.id === 4 ? "color" : "lighten"}`,
              zIndex: 1,
            }}
          >
            <Image
              src={feature.icon}
              alt={feature.title}
              width={150}
              height={150}
              className="group-hover/item:scale-105 transition-all ease-out duration-300 z-10"
            />
            <div>
              <h2
                className={`${
                  feature.id === 4 ? "text-subtitles" : "text-subtitles"
                } mb-2 font-semibold text-[20px] group-hover/item:scale-105 transition-all ease-out duration-300 opacity-100 z-10`}
              >
                {feature.title}
              </h2>
              <p
                className={`${
                  feature.id === 4 ? "text-subtitles" : "text-subtitles"
                } text-[13px] font-light group-hover/item:scale-105 transition-all ease-out duration-300 pb-4 opacity-100`}
              >
                {feature.content}
              </p>
              <BrandHeader navbar={false} />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Features;
