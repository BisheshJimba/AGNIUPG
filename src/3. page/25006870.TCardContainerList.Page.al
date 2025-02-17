page 25006870 "TCard Container List"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = Table25006870;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Type; Type)
                {

                    trigger OnValidate()
                    begin
                        IF ((Rec.Subtype = Rec.Subtype::"In Progress") OR (Rec.Subtype = Rec.Subtype::Finished)) AND (Rec.Type <> Rec.Type::Order) THEN
                            ERROR(TypeAndSubtypeErr);
                    end;
                }
                field(Subtype; Subtype)
                {

                    trigger OnValidate()
                    begin
                        IF (Rec.Subtype <> Rec.Subtype::"In Progress") AND ((Rec."Resource No." <> '') OR (Rec."Service Advisor" <> '')) THEN
                            ERROR(SubtypeServResErr);

                        IF ((Rec.Subtype = Rec.Subtype::"In Progress") OR (Rec.Subtype = Rec.Subtype::Finished)) AND (Rec.Type <> Rec.Type::Order) THEN
                            ERROR(TypeAndSubtypeErr);
                    end;
                }
                field(Name; Name)
                {
                }
                field(Enabled; Enabled)
                {
                }
                field("Container Size"; "Container Size")
                {
                }
                field("Configured Size"; "Configured Size")
                {
                    Visible = false;
                }
                field("Container Color"; "Container Color")
                {
                }
                field(PositionX; PositionX)
                {
                    Visible = false;
                }
                field(PositionY; PositionY)
                {
                    Visible = false;
                }
                field("Resource No."; "Resource No.")
                {

                    trigger OnValidate()
                    begin
                        IF ("Resource No." <> '') AND (Subtype <> Rec.Subtype::"In Progress") THEN
                            ERROR(SubtypeResourceErr);
                    end;
                }
                field("Service Advisor"; "Service Advisor")
                {

                    trigger OnValidate()
                    begin
                        IF ("Service Advisor" <> '') AND (Subtype <> Rec.Subtype::"In Progress") THEN
                            ERROR(SubtypeServicePersErr);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        SubtypeResourceErr: Label 'Only Entries with Subtype "In Progress", can have Resource No.';
        SubtypeServicePersErr: Label 'Only Entries with Subtype "In Progress", can have Service Person';
        SubtypeServResErr: Label 'Only Entries with Subtype "In Progress", can have Service Person or Resource No.';
        TypeAndSubtypeErr: Label 'Subtypes "In Progress" and "Finished" can only be set together with Type "Order"';
}

