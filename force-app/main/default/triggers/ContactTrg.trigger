trigger ContactTrg on Contact (before insert) {
    InsuranceRates rates = new InsuranceRates();
    Decimal baseCost = InsuranceRates.smokerCharge;

}