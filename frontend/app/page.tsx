import CTA from "@/components/home/CTA";
import Features from "@/components/home/Features";
import Footer from "@/components/home/Footer";
import Hero from "@/components/home/Hero";
import Navbar from "@/components/home/Navbar";
import Works from "@/components/home/Works";

export default function Home() {
  return (
    <>
      <div className="hidden md:block font-[family-name:var(--font-geist-sans)]">
        <Navbar />
        <Hero />
        <Features />
        <Works />
        <CTA />
        <Footer />
      </div>
      <div className="flex md:hidden justify-center items-center mt-16 font-[family-name:var(--font-montserrat)] h-screen">
        <h1 className="text-[30px] text-black font-semibold text-center">
          {" "}
          Not Available on Mobile
        </h1>
      </div>
    </>
  );
}
