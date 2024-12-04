import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const HackathonFactoryModule = buildModule("HackathonFactoryModule", (m) => {
  const hackathonFactory = m.contract("HackathonFactory");

  return { hackathonFactory };
});

export default HackathonFactoryModule;
