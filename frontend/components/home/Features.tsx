import React from "react";

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
      <p className="text-gray-700 text-[16px] mt-4 font-light">
        At Hackathon Solutions, we simplify post-hackathon reward management.
        Whether you are organizing a global event or a local sprint, our
        platform ensures bounties are distributed fairly, quickly, and with
        precision.
      </p>
    </div>
  );
}

export default Features;
