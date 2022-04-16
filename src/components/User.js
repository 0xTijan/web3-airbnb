import React, { useState, useEffect } from "react";
import { Icon, Modal, Card } from "web3uikit";
import { useMoralis } from "react-moralis";


function User({ user }) {
  const [open, setOpen] = useState(false);
  const { Moralis } = useMoralis();
  const [userRentals, setUserRentals] = useState();
  
  useEffect(() => {
    (async function get() {
      const Rentals = Moralis.Object.extend("newBookings");
      const query = new Moralis.Query(Rentals);
      query.equalTo("booker", user.get("ethAddress"));
      const result = await query.find();
      setUserRentals(result);
    })()
  }, [open]);

  return (
    <>
      <div onClick={() => setOpen(true)}>
        <Icon fill="#000000" size={24} svg="user" />
      </div>

      <Modal
        onCloseButtonPressed={() => setOpen(false)}
        hasFooter={false}
        title="Your Stays"
        isVisible={open}
      >
        <div style={{display:"flex", justifyContent:"start", flexWrap:"wrap", gap:"10px"}}>
          {userRentals &&
            userRentals.map((e)=>{
              return(
                <div style={{ width: "200px" }}>
                  <Card
                    isDisabled
                    title={e.attributes.city}
                    description={`${e.attributes.datesBooked[0]} for ${e.attributes.datesBooked.length} Days`}
                  >
                    <div>
                      <img
                        width="180px"
                        src={e.attributes.imgUrl}
                      />
                    </div>
                  </Card>
                </div>
              )
            })
          }
        </div>
      </Modal>
    </>
  );
}

export default User;
