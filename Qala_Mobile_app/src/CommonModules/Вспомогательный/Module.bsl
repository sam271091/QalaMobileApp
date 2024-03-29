
Функция НастройкиЗаполнены() Экспорт 
	
	НастройкиЗаполнены = Истина;
	
	Если Не ЗначениеЗаполнено(Константы.Сервер.Получить()) Тогда 
		НастройкиЗаполнены = Ложь;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Константы.Пользователь.Получить()) Тогда 
		НастройкиЗаполнены = Ложь;
	КонецЕсли;
	
	Если Не Константы.НастройкиЗаполнены.Получить() Тогда 
		НастройкиЗаполнены = Ложь;
	КонецЕсли;	
	
	Возврат НастройкиЗаполнены;
	
КонецФункции


Функция НастройкиОбменаЗаполнены() Экспорт 
	
	НастройкиЗаполнены = Истина;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МобОбмен.Ссылка КАК Ссылка,
	               |	МобОбмен.ЭтотУзел КАК ЭтотУзел,
	               |	МобОбмен.Код КАК Код
	               |ИЗ
	               |	ПланОбмена.МобОбмен КАК МобОбмен";
	
    Выборка = Запрос.Выполнить().Выбрать();	
	
	Если Выборка.Количество() = 1 Тогда 
		НастройкиЗаполнены = Ложь;		
	КонецЕсли;	
	
	Выборка.Следующий();
	
	Если Не ЗначениеЗаполнено(Выборка.Код) Тогда 
		НастройкиЗаполнены = Ложь;		
	КонецЕсли;	
	
	Если  Не Константы.НастройкиЗаполнены.Получить() Тогда 
		НастройкиЗаполнены = Ложь;		
	КонецЕсли;	
	
	Возврат НастройкиЗаполнены;

	
	
КонецФункции	


Процедура ПроверитьИдентификаторНаСервере() Экспорт 
    
    // Системная информация
	Если НЕ ЗначениеЗаполнено(Константы.IDКлиента.Получить()) Тогда
        
        СИ = Новый СистемнаяИнформация;
		Константы.IDКлиента.Установить(СИ.ИдентификаторКлиента);                
	КонецЕслИ;
    
КонецПроцедуры



Функция ПроверитьВыполнениеФЗ(Ключ) Экспорт 
	Структура = Новый Структура;
	Структура.Вставить("Ключ",Ключ);
	ФЗ = ФоновыеЗадания.ПолучитьФоновыеЗадания(Структура);
	
			

	Если ФЗ.Количество() > 0 Тогда
		ПоследнееФЗ = ФЗ.Получить(0);
		
		Если ПоследнееФЗ.ИнформацияОбОшибке = Неопределено Тогда 
			Возврат Ложь;
		КонецЕсли;	
		
		Возврат ПоследнееФЗ.ИнформацияОбОшибке.Описание;
	КонецЕсли;	
	Возврат Ложь;
КонецФункции



Процедура ДобавитьВРегистрОповещенийНаСервере(СтруктураДанных) Экспорт 
	МенеджерЗаписи = РегистрыСведений.Уведомления.СоздатьМенеджерЗаписи();
	Если СтруктураДанных.ТипДокумента = "ВнутреннийЗаказ" Тогда 
		СсылкаДок =  Документы.ВнутреннийЗаказ.ПолучитьСсылку(Новый УникальныйИдентификатор(СтруктураДанных.IDДок));
	ИначеЕсли СтруктураДанных.ТипДокумента = "ЗаказПоставщику" Тогда 
		СсылкаДок =  Документы.ЗаказПоставщику.ПолучитьСсылку(Новый УникальныйИдентификатор(СтруктураДанных.IDДок));
	ИначеЕсли СтруктураДанных.ТипДокумента = "ЗаявкаНаРасходованиеДС" Тогда 
		СсылкаДок =  Документы.ЗаявкиНаРсходованиеСредств.ПолучитьСсылку(Новый УникальныйИдентификатор(СтруктураДанных.IDДок));	
	КонецЕсли;
	МенеджерЗаписи.Период = ТекущаяДата();
	МенеджерЗаписи.Документ = СсылкаДок;
	МенеджерЗаписи.Показан = Ложь;
	МенеджерЗаписи.Записать();

КонецПроцедуры	

Процедура ДобавитьПрочитанВРегистрОповещенийНаСервере(Ссылка) Экспорт 
	НаборЗаписей = РегистрыСведений.Уведомления.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Значение =  Ссылка;
	НаборЗаписей.Отбор.Документ.Использование = Истина;
	//НаборЗаписей.Отбор.Показан.Значение = Истина;
	НаборЗаписей.Прочитать();
	
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
	
	
	МенеджерЗаписи = РегистрыСведений.Уведомления.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДата();
	МенеджерЗаписи.Документ = Ссылка;
	МенеджерЗаписи.Показан = Истина;
	МенеджерЗаписи.Записать();

КонецПроцедуры


