import Image from "next/image";
import React from "react";

type TSteps = {
  id: number;
  title: string;
  content: string;
  svgImage: string;
};

const steps: TSteps[] = [
  {
    id: 1,
    title: "Host a Hackathon",
    content:
      "Launch your hackathon with ease! Whether it’s a small-scale local event or a global competition, Hackathon Solutions provides tools to manage participants, projects, and criteria. From registration to submission tracking, we support you every step of the way to ensure your event runs smoothly.",
    svgImage: "/one.svg",
  },
  {
    id: 2,
    title: "Configure Bounty Rules",
    content:
      "Set reward structures, criteria, and amounts. Set tiered rewards (e.g., 1st place gets $1,000, 2nd place gets $500, etc.). Offer participation bounties for all contributors. Customize rewards by criteria such as categories, tasks completed, or special sponsor recognitions.",
    svgImage: "/two.svg",
  },
  {
    id: 3,
    title: "Customizable Rewards",
    content:
      "With a single click, our ninja algorithms ensure rewards are distributed promptly and accurately. Notifications are sent to participants, letting them know what they earned and why. Multiple payout options, such as bank transfers, crypto, or gift cards, are supported.",
    svgImage: "/three.svg",
  },
];

function Steps({ step }: { step: TSteps }) {
  return (
    <div className="p-4 my-4 rounded-lg bg-[s#F4FBFF] hover:shadow-lg hover:bg-white duration-300 ease-out transition-all cursor-pointer flex gap-4 items-center w-[720px] h-[155px] group/item hover:scale-105">
      <div className="w-3/4 flex items-center justify-center">
        <Image
          src={step.svgImage}
          alt="step"
          width={50}
          height={50}
          className="w-[60px] h-[60px] group-hover/item:scale-105 transition-all ease-out duration-300 z-10"
        />
      </div>
      <div>
        <h1 className="text-[20px] font-semibold group-hover/item:scale-105 transition-all ease-out duration-300 z-10">
          {step.title}
        </h1>
        <p className="text-gray-700 text-[13px] mt-2 font-light group-hover/item:scale-105 transition-all ease-out duration-300 leading-relaxed z-10">
          {step.content}
        </p>
      </div>
    </div>
  );
}

function Works() {
  return (
    <div className="font-[family-name:var(--font-montserrat)] mt-32 mx-8 flex gap-2 justify-between items-center">
      <div>
        <h1 className="w-full text-[40px] font-semibold text-titles max-w-xl">
          How it Works
        </h1>
        <h1 className="w-full text-[40px] font-semibold max-w-3xl">
          Our platform streamlines every step
        </h1>
        <h1 className="w-full text-[40px] font-semibold max-w-xl">
          of the process
        </h1>
        <p className="text-gray-700 text-[16px] mt-4 font-light mb-8 max-w-3xl">
          At Hackathon Solutions, we simplify post-hackathon reward management.
          Whether you are organizing a global event or a local sprint, our
          platform ensures bounties are distributed fairly, quickly, and with
          precision.
        </p>
        {steps.map((step) => (
          <Steps key={step.id} step={step} />
        ))}
      </div>
      <div className="relative">
        <Image
          src="/pen.svg"
          alt="pen"
          width={150}
          height={150}
          className="h-full w-full"
        />
        <Image
          src="/pen-shadow.svg"
          alt="pen-shadow"
          width={150}
          height={150}
          className="h-full w-full absolute left-16 top-16 z-[-10]"
        />
      </div>
    </div>
  );
}

export default Works;
