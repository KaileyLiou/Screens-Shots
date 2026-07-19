# Screens + Shots
Screens + Shots is a health reminder app that helps users stay on top of vaccines and cancer screenings. With a simple, personalized profile, the app generates tailored recommendations and highlights the next upcoming health reminder. It is designed to make it easy for both adults and children to stay up to date with important preventive care.

## Technical Features
- **Personalized recommendations:** Uses a user's age, gender, date of birth, conditions, and family history to inform tailored health guidance based on current CDC/USPSTF guidelines.
- **Profile management:** Allows users to create, edit, or fully reset their profile data.
- **Upcoming reminder highlights:** Easily see the next recommended vaccine or screening.
- **Reminder dashboard:** View past and upcoming reminders, add custom ones, edit existing ones, and multi-select to delete several at once.
- **Explanations:** Users can tap an info icon on any reminder to see a plain-language explanation of why it matters.
- **Configurable notifications:** Choose your own daily reminder time, or turn notifications off entirely.
- **Timely alerts:** Supports vaccinations for children and adults and cancer screenings for adults, including recurring reminders that recalculate their next real due date automatically.
- **iPad support:** Layouts adapt so the app doesn't feel stretched on a larger screen.

## Screenshots
<p>
  <img src="https://github.com/user-attachments/assets/f7f3363c-90da-45be-b76f-a9b1d2d78ec9" width="35%" />
  <img src="https://github.com/user-attachments/assets/fb340e04-6b81-4d64-aa62-a6d9b45b6c03" width="35%" />
</p>
<p>
  <img src="https://github.com/user-attachments/assets/38f1b970-6a12-4a17-9e71-dd26e4e67ee8" width="45%" />
  <img src="https://github.com/user-attachments/assets/36b83d2e-18c5-4e83-880f-b8d2b9e5e606" width="45%" />
</p>

## How It Works
The app is built entirely in Swift using SwiftUI for a clean and intuitive interface. User profiles and reminders are stored locally on-device, and reminders are generated from real CDC/USPSTF guidelines and are based on the user’s personal health information. Notifications alert users when a vaccine or screening is due (at a time the user can customize in Settings), making preventive care easy to follow.

## Challenges & Lessons Learned
- **Matching evolving medical rules:** Mapping the code to actual CDC and USPSTF guidelines was a lot harder than expected. For example, during testing, I realized my code didn't have an upper age limit for cervical screenings. I also had to update the logic to handle individualized recommendations based on doctor-patient choice rather than strict due dates following a recent CDC update.
- **Multi-select delete feature:** Getting the multi-select delete to work without crashing the app was a major hurdle. When a user selected multiple reminders and hit delete, the app's internal list would change while the deletion was still running, which caused index errors. I had to fix this by separating the user's selections from the core data list until the delete action actually finished.
- **Making it responsive on iPads:** I built the interface using SwiftUI, which works great for iPhones but stretches things out on iPads. I had to learn how to use responsive layout tools so the columns and spacing dynamically adapt depending on the screen size.

## Future Improvements
- **Mark as done:** Build a state handler to let users mark reminders as completed and automatically trigger the next recurring date.
- **Full dark mode support:** Transition hardcoded colors to asset catalogs to fully support system dark mode.
- **Accessibility:** Implement Dynamic Type so the text layout responds to the system font sizes.
- **Cross-device support:** Sync reminders and profiles across multiple devices.

## Built With
- Swift & SwiftUI
- Xcode

## Disclaimer
This app provides general health information and is not medical advice. Consult a doctor before making decisions.

**App Store Link:** [Download Screens + Shots](https://apps.apple.com/app/screens-shots/id6755749446)
