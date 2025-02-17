page 50044 "Vehicles with flowfileds"
{
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019823;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Serial No."; "Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Insurance Policy No."; "Insurance Policy No.")
                {
                }
                field("Current Location of Vehicle"; "Current Location of Vehicle")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field(Inventory; Inventory)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        CompwiseMakeSetup.RESET;
        CompwiseMakeSetup.SETRANGE("Company Name", COMPANYNAME);
        IF CompwiseMakeSetup.FINDFIRST THEN BEGIN
            SETFILTER("Make Code", CompwiseMakeSetup."Make Code Filter");
        END; //Uncommentd by Amisha for make code wise vehicle filter

        FILTERGROUP(0);
    end;

    var
        CompwiseMakeSetup: Record "33019876";
}

