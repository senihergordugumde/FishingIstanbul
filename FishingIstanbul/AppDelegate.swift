//
//  AppDelegate.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 4.07.2024.
//

import UIKit
import FirebaseCore
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let fishGoal = UserDefaults.standard.object(forKey: "goalTimer") as? Date {
                    //print("Zamanlayıcı \(fishGoal) : Tarih \(Date())")
                    if fishGoal < Date(){
                  
                        let stepperValue =  UserDefaults.standard.double(forKey: "stepperValue")
                        
                        if var fishCountList = UserDefaults.standard.value(forKey: "fishCountList") as? [Double]{
                            fishCountList.append(stepperValue)
                            UserDefaults.standard.set(fishCountList, forKey: "fishCountList")
                            print("FishCountListBulundu ve yeni değer eklendi \(fishCountList)")
                        }
                        
                        else{
                            UserDefaults.standard.set([stepperValue], forKey: "fishCountList")
                            print("FishCountListBulunamadı ama yeni değer oluşturuldu \(stepperValue)")
                        }
                        
                        
                        UserDefaults.standard.set(0, forKey: "stepperValue")
                        print("stepper sıfırlandı")
                        
                        if var dates = UserDefaults.standard.value(forKey: "dates") as? [String]{
                            let currentDate = Date().formatted()
                            dates.append(currentDate)
                            UserDefaults.standard.set(Date().addingTimeInterval(7*24*60*60), forKey: "goalTimer") // tarihi otomatik olarak yeninden ayarlar
                            UserDefaults.standard.set(dates, forKey: "dates")
                            print("dates bulundu \(dates)")

                        }
                        else{
                            //Eğer UserDefaults 'dates' henüz oluşmadıysa (Örneğin; uygulama ilk kez açıldı)
                            UserDefaults.standard.set([Date().formatted()], forKey: "dates")
                            UserDefaults.standard.set(Date().addingTimeInterval(7*24*60*60), forKey: "goalTimer")
                            print("dates bulunamadı")
                        }
                    
                     }else{
                         
                        print("süre henüz dolmadı")
                     }
                print("\(fishGoal) hedeef")
            
        }
   
       
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

