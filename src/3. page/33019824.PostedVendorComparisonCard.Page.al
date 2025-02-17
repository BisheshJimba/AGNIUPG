page 33019824 "Posted Vendor Comparison Card"
{
    PageType = Document;
    SourceTable = Table33019818;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("Item Product Group"; "Item Product Group")
                {
                }
                field("Chart No."; "Chart No.")
                {
                }
            }
            part(; 33019819)
            {
                SubPageLink = Approval Code=FIELD(Fiscal Year),
                              Line No.=FIELD(Item Product Group),
                              Field16=FIELD(Chart No.);
            }
            group()
            {
                field("Vendor 1 Total";"Vendor 1 Total")
                {
                }
                field("Vendor 2 Total";"Vendor 2 Total")
                {
                }
                field("Vendor 3 Total";"Vendor 3 Total")
                {
                }
                field("Vendor 4 Total";"Vendor 4 Total")
                {
                }
                field("Vendor 5 Total";"Vendor 5 Total")
                {
                }
                field("Vendor 6 Total";"Vendor 6 Total")
                {
                }
                field("Vendor 7 Total";"Vendor 7 Total")
                {
                }
                field("Vendor 8 Total";"Vendor 8 Total")
                {
                }
                field("Vendor 9 Total";"Vendor 9 Total")
                {
                }
                field("Vendor 10 Total";"Vendor 10 Total")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //Hiding fields if Vendor totals are blank.
        CALCFIELDS("Vendor 1 Total","Vendor 2 Total","Vendor 3 Total","Vendor 4 Total","Vendor 5 Total","Vendor 6 Total","Vendor 7 Total",
        "Vendor 8 Total","Vendor 9 Total","Vendor 10 Total");

        IF ("Vendor 1 Total" = 0) THEN
          GblHideVendor1 := FALSE
        ELSE
          GblHideVendor1 := TRUE;

        IF ("Vendor 2 Total" = 0) THEN
          GblHideVendor2 := FALSE
        ELSE
          GblHideVendor2 := TRUE;

        IF ("Vendor 3 Total" = 0) THEN
          GblHideVendor3 := FALSE
        ELSE
          GblHideVendor3 := TRUE;

        IF ("Vendor 4 Total" = 0) THEN
          GblHideVendor4 := FALSE
        ELSE
          GblHideVendor4 := TRUE;

        IF ("Vendor 5 Total" = 0) THEN
          GblHideVendor5 := FALSE
        ELSE
          GblHideVendor5 := TRUE;

        IF ("Vendor 6 Total" = 0) THEN
          GblHideVendor6 := FALSE
        ELSE
          GblHideVendor6 := TRUE;

        IF ("Vendor 7 Total" = 0) THEN
          GblHideVendor7 := FALSE
        ELSE
          GblHideVendor7 := TRUE;

        IF ("Vendor 8 Total" = 0) THEN
          GblHideVendor8 := FALSE
        ELSE
          GblHideVendor8 := TRUE;

        IF ("Vendor 9 Total" = 0) THEN
          GblHideVendor9 := FALSE
        ELSE
          GblHideVendor9 := TRUE;

        IF ("Vendor 10 Total" = 0) THEN
          GblHideVendor10 := FALSE
        ELSE
          GblHideVendor10 := TRUE;
    end;

    trigger OnOpenPage()
    begin
        /*
        //Hiding fields if Vendor totals are blank.
        CALCFIELDS("Vendor 1 Total","Vendor 2 Total","Vendor 3 Total","Vendor 4 Total","Vendor 5 Total","Vendor 6 Total","Vendor 7 Total",
        "Vendor 8 Total","Vendor 9 Total","Vendor 10 Total");
        
        IF ("Vendor 1 Total" = 0) THEN
          GblHideVendor1 := FALSE
        ELSE
          GblHideVendor1 := TRUE;
        
        IF ("Vendor 2 Total" = 0) THEN
          GblHideVendor2 := FALSE
        ELSE
          GblHideVendor2 := TRUE;
        
        IF ("Vendor 3 Total" = 0) THEN
          GblHideVendor3 := FALSE
        ELSE
          GblHideVendor3 := TRUE;
        
        IF ("Vendor 4 Total" = 0) THEN
          GblHideVendor4 := FALSE
        ELSE
          GblHideVendor4 := TRUE;
        
        IF ("Vendor 5 Total" = 0) THEN
          GblHideVendor5 := FALSE
        ELSE
          GblHideVendor5 := TRUE;
        
        IF ("Vendor 6 Total" = 0) THEN
          GblHideVendor6 := FALSE
        ELSE
          GblHideVendor6 := TRUE;
        
        IF ("Vendor 7 Total" = 0) THEN
          GblHideVendor7 := FALSE
        ELSE
          GblHideVendor7 := TRUE;
        
        IF ("Vendor 8 Total" = 0) THEN
          GblHideVendor8 := FALSE
        ELSE
          GblHideVendor8 := TRUE;
        
        IF ("Vendor 9 Total" = 0) THEN
          GblHideVendor9 := FALSE
        ELSE
          GblHideVendor9 := TRUE;
        
        IF ("Vendor 10 Total" = 0) THEN
          GblHideVendor10 := FALSE
        ELSE
          GblHideVendor10 := TRUE;
        */

    end;

    var
        GblPrcDocMngt: Codeunit "33019810";
        [InDataSet]
        GblHideVendor1: Boolean;
        [InDataSet]
        GblHideVendor2: Boolean;
        [InDataSet]
        GblHideVendor3: Boolean;
        [InDataSet]
        GblHideVendor4: Boolean;
        [InDataSet]
        GblHideVendor5: Boolean;
        [InDataSet]
        GblHideVendor6: Boolean;
        [InDataSet]
        GblHideVendor7: Boolean;
        [InDataSet]
        GblHideVendor8: Boolean;
        [InDataSet]
        GblHideVendor9: Boolean;
        [InDataSet]
        GblHideVendor10: Boolean;
}

