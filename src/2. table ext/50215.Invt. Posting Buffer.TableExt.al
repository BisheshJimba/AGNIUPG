tableextension 50215 tableextension50215 extends "Invt. Posting Buffer"
{
    // 11.04.2008 EDMS P3
    //   * Added new account type: Veh. Additionl Expenses
    fields
    {
        modify("Account Type")
        {
            OptionCaption = 'Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance,Veh. Additional Expenses';

            //Unsupported feature: Property Modification (OptionString) on ""Account Type"(Field 1)".

        }

        //Unsupported feature: Property Modification (OptionString) on ""Bal. Account Type"(Field 14)".

    }
}

