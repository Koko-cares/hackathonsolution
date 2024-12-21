import type { Metadata } from "next";
import { Kode_Mono, Montserrat } from "next/font/google";
import "./globals.css";
import Head from "next/head";

const montserrat = Montserrat({
  variable: "--font-montserrat",
  subsets: ["latin"],
});

const kodeMono = Kode_Mono({
  variable: "--font-kode-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Hackathon Solutions",
  description: "For Hackathon Ninjas Globally",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <Head>
        <link rel="icon" href="../public/logo.ico" />
      </Head>
      <body
        className={`${montserrat.variable} ${kodeMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
