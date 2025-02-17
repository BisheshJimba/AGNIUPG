tableextension 50035 tableextension50035 extends "Incoming Document"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Vendor Name"(Field 23)".

        field(50001; "File Name"; Text[250])
        {
        }
    }

    procedure SetHirePurchDoc(var VehicleFinanceAppHeader: Record "Vehicle Finance App. Header")
    begin
        // IF VehicleFinanceAppHeader."Incoming Document Entry No." = 0 THEN//need to solve table error
        //     EXIT;
        // GET(VehicleFinanceAppHeader."Incoming Document Entry No.");//need to solve table error
        TestReadyForProcessing;
        // TestIfAlreadyExists;//function does not exist
        /*CASE PurchaseHeader."Document Type" OF
          PurchaseHeader."Document Type"::Invoice:
            "Document Type" := "Document Type"::"Purchase Invoice";
          PurchaseHeader."Document Type"::"Credit Memo":
            "Document Type" := "Document Type"::"Purchase Credit Memo";
        END;*/
        MODIFY;
        // IF NOT DocLinkExists(VehicleFinanceAppHeader) THEN// function does not exist
        VehicleFinanceAppHeader.ADDLINK(GetURL, Description);

    end;
}

