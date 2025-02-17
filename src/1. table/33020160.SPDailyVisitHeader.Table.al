table 33020160 "SP Daily Visit Header"
{

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            TableRelation = Salesperson/Purchaser;
        }
        field(2;Year;Integer)
        {
            NotBlank = true;
            TableRelation = "English Year";
        }
        field(3;"Week No";Integer)
        {
            NotBlank = true;
        }
        field(4;Posted;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Salesperson Code",Year,"Week No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //Deleting records.
        gblSPDVisitLine.RESET;
        gblSPDVisitLine.SETRANGE("Salesperson Code","Salesperson Code");
        gblSPDVisitLine.SETRANGE(Year,Year);
        gblSPDVisitLine.SETRANGE("Week No","Week No");
        IF gblSPDVisitLine.FIND('-') THEN
          gblSPDVisitLine.DELETEALL;

        gblSPDvisitDetails.RESET;
        gblSPDvisitDetails.SETRANGE("Salesperson Code","Salesperson Code");
        gblSPDvisitDetails.SETRANGE(Year,Year);
        gblSPDvisitDetails.SETRANGE("Week No","Week No");
        IF gblSPDvisitDetails.FIND('-') THEN
          gblSPDvisitDetails.DELETEALL;
    end;

    var
        gblSPDVisitLine: Record "33020161";
        gblSPDvisitDetails: Record "33020201";
}

