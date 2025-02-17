table 33019985 "Void Fuel Issue"
{

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = 'Coupon,Stock,Cash';
            OptionMembers = Coupon,Stock,Cash;
        }
        field(2; "Coupon No."; Code[20])
        {

            trigger OnLookup()
            begin
                //Selecting coupon no. on the basis of type selected.
                IF Type = Type::Coupon THEN BEGIN
                    GblPostedFuelIssueEntry.RESET;
                    GblPostedFuelIssueEntry.SETFILTER("Document Type", 'Coupon');
                    IF PAGE.RUNMODAL(0, GblPostedFuelIssueEntry) = ACTION::LookupOK THEN
                        "Coupon No." := GblPostedFuelIssueEntry."No.";
                END ELSE
                    IF Type = Type::Stock THEN BEGIN
                        GblPostedFuelIssueEntry.RESET;
                        GblPostedFuelIssueEntry.SETFILTER("Document Type", 'Stock');
                        IF PAGE.RUNMODAL(0, GblPostedFuelIssueEntry) = ACTION::LookupOK THEN
                            "Coupon No." := GblPostedFuelIssueEntry."No.";
                    END ELSE
                        IF Type = Type::Cash THEN BEGIN
                            GblPostedFuelIssueEntry.RESET;
                            GblPostedFuelIssueEntry.SETFILTER("Document Type", 'Cash');
                            IF PAGE.RUNMODAL(0, GblPostedFuelIssueEntry) = ACTION::LookupOK THEN
                                "Coupon No." := GblPostedFuelIssueEntry."No.";
                        END;
            end;
        }
        field(3; Void; Boolean)
        {
        }
        field(4; "Responsibility Center"; Code[10])
        {
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; Type, "Coupon No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        GblUserSetup.GET(USERID);
        "Responsibility Center" := GblUserSetup."Default Responsibility Center";
        "Accountability Center" := GblUserSetup."Default Accountability Center";
    end;

    var
        GblUserSetup: Record "91";
        GblPostedFuelIssueEntry: Record "33019967";
}

