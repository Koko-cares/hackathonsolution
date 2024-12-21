import React from "react";
import { BrandHeader } from "./Navbar";
import {
  IconBrandDiscord,
  IconBrandTelegram,
  IconBrandWhatsapp,
  IconBrandX,
} from "@tabler/icons-react";

type TFooterContent = {
  id: number;
  title: string;
  contents: string[];
};

const footerContents: TFooterContent[] = [
  {
    id: 1,
    title: "Product",
    contents: [
      "What's Hackathon Solutions",
      "Why Hackathon Solutions",
      "How it Works",
      "Join Us Today",
      "Privacy Policy",
    ],
  },
  {
    id: 2,
    title: "Hackathon",
    contents: [
      "Hackathon List",
      "Features",
      "Available Discouts",
      "FAQ",
      "Terms of Service",
    ],
  },
  {
    id: 3,
    title: "Grants & Bounties",
    contents: [
      "Grants",
      "Bounties",
      "Categories",
      "Invetsors & Contributors",
      "Partner Programs",
    ],
  },
  {
    id: 4,
    title: "Projects",
    contents: ["Hosted Projects", "Open Source Projects", "Launched Projects"],
  },
];

function FooterContent({ content }: { content: TFooterContent }) {
  return (
    <div className="w-[200px]">
      <h1 className="font-bold text-[16px]">{content.title}</h1>
      <div className="flex flex-col gap-2">
        {content.contents.map((content, index) => (
          <p
            key={index}
            className="text-[13px] py-1 hover:text-brand hover:underline cursor-pointer ease-in duration-200 transition-all"
          >
            {content}
          </p>
        ))}
      </div>
    </div>
  );
}

function Footer() {
  return (
    <div className="font-[family-name:var(--font-montserrat)] mt-32 flex flex-col gap-2 items-center w-[100%]">
      <div className="bg-gray-500 h-[0.1px] w-full"></div>
      <div className="flex lg:gap-16 items-start md:justify-between lg:justify-normal gap-16">
        <div className="w-1/4 mt-8">
          <BrandHeader navbar />
          <div className="flex mt-4 gap-4 items-center">
            <IconBrandDiscord
              size={30}
              className="hover:text-brand transition-all ease-in duration-200 hover:scale-105 cursor-pointer"
            />
            <IconBrandX
              size={30}
              className="hover:text-brand transition-all ease-in duration-200 hover:scale-105 cursor-pointer"
            />
            <IconBrandTelegram
              size={30}
              className="hover:text-brand transition-all ease-in duration-200 hover:scale-105 cursor-pointer"
            />
            <IconBrandWhatsapp
              size={30}
              className="hover:text-brand transition-all ease-in duration-200 hover:scale-105 cursor-pointer"
            />
          </div>
        </div>
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-8 w-3/4 mt-8">
          {footerContents.map((content) => (
            <FooterContent key={content.id} content={content} />
          ))}
        </div>
      </div>
      <div className="bg-gray-500 h-[0.1px] my-2 w-full"></div>
      <p className="text-gray-900 text-[14px] mt-4 font-bold mb-4">
        copy right© 2025. Location: Everywhere you go. Hacker Team.
      </p>
    </div>
  );
}

export default Footer;
