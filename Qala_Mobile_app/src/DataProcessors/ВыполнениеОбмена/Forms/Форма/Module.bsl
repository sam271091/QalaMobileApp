
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.ВидОбмена = Перечисления.ВидыОбмена.Загрузка;
КонецПроцедуры



&НаКлиенте 
Процедура КомандаВыполнитьНажатие(Команда) 
	//стартуем выполнение длительной операции на сервере в фоновом задании 
	КомандаВыполнитьНажатиеНаСервере(); 
	//подключаем обработчик ожидания для мониторинга выполнения процесса 
	ПодключитьОбработчикОжидания("ОбработчикОжидания",0.1,Истина); 
КонецПроцедуры

&НаСервере 
Процедура КомандаВыполнитьНажатиеНаСервере() 
	
	АдресХранилища = ПоместитьВоВременноеХранилище( Новый Структура("Инд,КоличествоОбходов,СтатусПодключения",0,1,Неопределено),ЭтаФорма.УникальныйИдентификатор); 
	МассивПараметров = Новый Массив; 
	МассивПараметров.Добавить(АдресХранилища); 
	Если Объект.ВидОбмена = Перечисления.ВидыОбмена.Загрузка Тогда 
		Ответ = Вспомогательный.ПроверитьВыполнениеФЗ(ПолучитьИмя());
		Если Ответ = Ложь Тогда 
			ФЗ = ФоновыеЗадания.Выполнить("МодульОбмена.ВыполнитьЗагрузкуДанных",МассивПараметров,"Загрузка"); 
		КонецЕсли;
	иначе
		Ответ = Вспомогательный.ПроверитьВыполнениеФЗ(ПолучитьИмя());
		Если Ответ = Ложь Тогда
			ФЗ = ФоновыеЗадания.Выполнить("МодульОбмена.ВыполнитьВыгрузкуДанных",МассивПараметров,"Выгрузка"); 
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры 

&НаСервере
Функция ПолучитьИмя()
	Возврат XMLСтрока(Объект.ВидОбмена);
КонецФункции	

&НаКлиенте 
Процедура ОбработчикОжидания() Экспорт 
	
	ДанныеОВыполнении = ПолучитьИзВременногоХранилища(АдресХранилища); 
	Если ТипЗнч(ДанныеОВыполнении) = Тип("Структура") Тогда 
		
		Если ЗначениеЗаполнено(ДанныеОВыполнении.СтатусПодключения) Тогда 
			Журнал = ДанныеОВыполнении.СтатусПодключения;			
		КонецЕсли;	
		
		Ответ = Вспомогательный.ПроверитьВыполнениеФЗ(ПолучитьИмя());
		
		Если Ответ = Ложь Тогда
			Индикатор = ДанныеОВыполнении.Инд*100/ДанныеОВыполнении.КоличествоОбходов; 
			Если ДанныеОВыполнении.Инд <> ДанныеОВыполнении.КоличествоОбходов Тогда 
				ПодключитьОбработчикОжидания("ОбработчикОжидания",0.1,Истина); 
			КонецЕсли; 
		Иначе 
			Журнал = Журнал + "
			|" + Ответ;
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если Не МобильноеПриложениеКлиент Тогда
	ВыполнитьОбработкуЗаданий();
	#КонецЕсли 
КонецПроцедуры
