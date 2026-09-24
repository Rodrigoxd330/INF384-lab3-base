# Etapa 1: instalación de dependencias
FROM public.ecr.aws/lambda/nodejs:20 AS builder

WORKDIR ${LAMBDA_TASK_ROOT}

# Copiar primero los archivos de dependencias para aprovechar la caché
COPY package.json package-lock.json ./

# Instalación reproducible usando el lock file
RUN npm ci --omit=dev


# Etapa 2: imagen final
FROM public.ecr.aws/lambda/nodejs:20

WORKDIR ${LAMBDA_TASK_ROOT}

# Copiar únicamente lo necesario desde la etapa de construcción
COPY --from=builder ${LAMBDA_TASK_ROOT}/node_modules ./node_modules

# Copiar el código de la aplicación
COPY src ./src

CMD ["src/handler.handler"]