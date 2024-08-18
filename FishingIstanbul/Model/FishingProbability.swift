//
//  FishingProbability.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 9.08.2024.
//

import Foundation


struct FishingProbability {

        let temperature: Double
        let wind_speed : Double
        let pressure : Double
        let uv_index : Double
        let precipitation_intensity: Double
        let visibility: Double
        let humidity: Double
        let hour: Int
   
    
    
    
    
    func calculateFishingProbability(params: FishingProbability) -> Double {
        // Parametre ağırlıkları
        let temperatureWeight = 0.2
        let windSpeedWeight = 0.3
        let pressureWeight = 0.15
        let uvIndexWeight = 0.05
        let precipitationIntensityWeight = 0.2
        let visibilityWeight = 0.05
        let humidityWeight = 0.05
        let hourWeight = 0.2
        
        // Sıcaklık skoru
        let temperature = params.temperature
        let temperatureScore: Double
        if 15 <= temperature && temperature <= 22 {
            temperatureScore = 1.0
        } else if 10 <= temperature && temperature <= 25 {
            temperatureScore = 0.7
        } else {
            temperatureScore = 0.3
        }
        
        // Rüzgar hızı skoru (fırtına etkisi dahil)
        let windSpeed = params.wind_speed
        let windSpeedScore: Double
        if windSpeed <= 10 {
            windSpeedScore = 1.0
        } else if windSpeed <= 20 {
            windSpeedScore = 0.7
        } else if windSpeed <= 30 {
            windSpeedScore = 0.4
        } else {
            windSpeedScore = 0.2 // Fırtına durumunda ciddi düşüş
        }
        
        // Basınç skoru
        let pressure = params.pressure
        let pressureScore: Double
        if 1015 <= pressure && pressure <= 1020 {
            pressureScore = 1.0
        } else if 1010 <= pressure && pressure <= 1025 {
            pressureScore = 0.7
        } else {
            pressureScore = 0.4
        }
        
        // UV İndeksi skoru
        let uvIndex = params.uv_index
        let uvIndexScore: Double
        if uvIndex <= 3 {
            uvIndexScore = 1.0
        } else if uvIndex <= 5 {
            uvIndexScore = 0.7
        } else {
            uvIndexScore = 0.4
        }
        
        // Yağış yoğunluğu skoru (fırtına etkisi dahil)
        let precipitationIntensity = params.precipitation_intensity
        let precipitationScore: Double
        if precipitationIntensity == 0 {
            precipitationScore = 1.0
        } else if precipitationIntensity <= 0.2 {
            precipitationScore = 0.5
        } else if precipitationIntensity <= 0.5 {
            precipitationScore = 0.3
        } else {
            precipitationScore = 0.1 // Yoğun yağış durumunda ciddi düşüş
        }
        
        // Görüş mesafesi skoru
        let visibility = params.visibility
        let visibilityScore: Double
        if visibility >= 10 {
            visibilityScore = 1.0
        } else if visibility >= 5 {
            visibilityScore = 0.5
        } else {
            visibilityScore = 0.2
        }
        
        // Nem skoru
        let humidity = params.humidity
        let humidityScore: Double
        if 50 <= humidity && humidity <= 70 {
            humidityScore = 1.0
        } else if 40 <= humidity && humidity <= 80 {
            humidityScore = 0.6
        } else {
            humidityScore = 0.3
        }
        
        // Saat skoru
        let hour = params.hour
        let hourScore: Double
        if (6 <= hour && hour <= 9) || (17 <= hour && hour <= 20) {
            hourScore = 1.0
        } else if 10 <= hour && hour <= 16 {
            hourScore = 0.7
        } else {
            hourScore = 0.4
        }

        // Toplam skoru ve ağırlıklı ortalamayı hesapla
        let weightedProbability = (
            (temperatureScore * temperatureWeight) +
            (windSpeedScore * windSpeedWeight) +
            (pressureScore * pressureWeight) +
            (uvIndexScore * uvIndexWeight) +
            (precipitationScore * precipitationIntensityWeight) +
            (visibilityScore * visibilityWeight) +
            (humidityScore * humidityWeight) +
            (hourScore * hourWeight)
        )
        
        // Sonuç yüzdelik olarak döndürülüyor
        return (weightedProbability * 100) - 20
    }
    
}


