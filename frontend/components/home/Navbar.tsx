"use client";
import React, { useState } from "react";
import { HoveredLink, Menu, MenuItem, ProductItem } from "../ui/navbar-menu";
import { cn } from "@/lib/utils";
import Image from "next/image";
import { IconSearch } from "@tabler/icons-react";

export function BrandHeader({ navbar }: { navbar?: boolean }) {
  return (
    <div className={`flex items-center space-x-2 ${navbar ? "pt-4" : ""}`}>
      <Image
        src="/logo.svg"
        width={30}
        height={30}
        alt="logo"
        className={`${
          navbar ? "" : "w-[20px] h-[20px]"
        } text-brand font-[family-name:var(--font-kode-mono)]`}
      />
      <h1
        className={`font-bold ${
          navbar ? "text-lg" : "text-[13px]"
        } text-brand font-[family-name:var(--font-kode-mono)]`}
      >
        Hackathon Solutions
      </h1>
    </div>
  );
}

function Navbar({ className }: { className?: string }) {
  const [active, setActive] = useState<string | null>(null);
  return (
    <div
      className={cn(
        "fixed inset-x-0 mx-auto z-50 w-full bg-white font-[family-name:var(--font-montserrat)]",
        className
      )}
    >
      <Menu setActive={setActive}>
        <BrandHeader />
        <MenuItem setActive={setActive} active={active} item="Products">
          <div className="flex space-x-2">
            <Image
              src="/product.svg"
              width={50}
              height={70}
              alt="product"
              className="h-full w-[181px]"
            />
            <div className="flex flex-col space-y-4">
              <BrandHeader />
              <p className="text-[13px] mb-4 text-gray-500">
                The Where Hackathon Ninjas Earn, Gain Their Tresure
              </p>
              <div className="flex flex-col gap-2 text-[13px]">
                <HoveredLink href="/products">
                  Why Hackathon Solutions
                </HoveredLink>
                <HoveredLink href="/products">How it works</HoveredLink>
                <HoveredLink href="/products">Join Us</HoveredLink>
              </div>
              <button className="rounded-[3px] bg-black text-white px-4 py-2 w-[65%] mt-4">
                Host a Hackathon
              </button>
            </div>
          </div>
        </MenuItem>
        <MenuItem
          setActive={setActive}
          active={active}
          item="Hackathons & Bounties"
        >
          <div className="flex space-x-2">
            <Image
              src="/hacks.svg"
              width={50}
              height={70}
              alt="product"
              className="h-full w-[181px]"
            />
            <div className="flex flex-col space-y-4">
              <BrandHeader />
              <p className="text-[13px] mb-4 text-gray-500">
                Empowering our Innovators, One Reward at a Time
              </p>
              <div className="flex items-center justify-between">
                <div className="flex flex-col gap-4 text-[13px]">
                  <HoveredLink href="/products">Grants</HoveredLink>
                  <HoveredLink href="/products">
                    Create a Grant Program
                  </HoveredLink>
                </div>
                <div className="flex flex-col gap-3 text-[13px]">
                  <HoveredLink href="/products">Bounties</HoveredLink>
                  <HoveredLink href="/products">
                    Create a Bounty Pool
                  </HoveredLink>
                  <HoveredLink href="/products">Hunt a Bounty</HoveredLink>
                </div>
              </div>
            </div>
          </div>
        </MenuItem>
        <MenuItem setActive={setActive} active={active} item="Projects">
          <div className="  text-sm grid grid-cols-2 gap-10 p-4">
            <ProductItem
              title="Algochurn"
              href="https://algochurn.com"
              src="https://assets.aceternity.com/demos/algochurn.webp"
              description="Prepare for tech interviews like never before."
            />
            <ProductItem
              title="Mergify"
              href="https://tailwindmasterkit.com"
              src="https://assets.aceternity.com/demos/tailwindmasterkit.webp"
              description="Unify your team's workflow and build better products."
            />
            <ProductItem
              title="Moonbeam"
              href="https://gomoonbeam.com"
              src="https://assets.aceternity.com/demos/Screenshot+2024-02-21+at+11.51.31%E2%80%AFPM.png"
              description="Never write from scratch again. Go from idea to blog in minutes."
            />
            <ProductItem
              title="Rogue"
              href="https://userogue.com"
              src="https://assets.aceternity.com/demos/Screenshot+2024-02-21+at+11.47.07%E2%80%AFPM.png"
              description="Respond to government RFPs, RFIs and RFQs 10x faster using AI"
            />
          </div>
        </MenuItem>
        <div className="flex items-center justify-between right-0 absolute mr-8">
          <IconSearch size={26} className="mx-4" />
          <button className="font-semibold text-base mx-4">Login</button>
          <button className="font-semibold text-base mx-4 py-2 rounded-[3px] px-4 bg-black text-white">
            Sign Up
          </button>
        </div>
      </Menu>
    </div>
  );
}

export default Navbar;
